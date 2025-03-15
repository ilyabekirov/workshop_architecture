class Book < ApplicationRecord
  include Ransackable
  include Searchkickable

  has_many :books_authors, dependent: :destroy
  has_many :authors, through: :books_authors
  accepts_nested_attributes_for :authors

  has_many :books_genres, dependent: :destroy
  has_many :genres, through: :books_genres
  accepts_nested_attributes_for :genres

  has_many :books_keywords, dependent: :destroy
  has_many :keywords, through: :books_keywords
  accepts_nested_attributes_for :keywords

  belongs_to :folder # , counter_cache: :books_count
  belongs_to :language # , counter_cache: :books_count

  validates :title, :libid, :size, :filename, presence: true

  PUBLIC_FIELDS = %w[id del ext filename folder_id id_value insno
                     language_id libid series serno size title
                     published_at updated_at created_at]
  RANSACK_ASSOCIATIONS = %w[authors books_authors books_genres books_keywords
                            folder genres keywords language]

  def search_data
    Elasticsearch::SearchDataFormatter.new(self).format(
      title: :title,
      libid: :libid,
      size: :size,
      filename: :filename,
      folder_id: :folder_id,
      language_id: :language_id,
      author_names: { relation: :authors, attributes: %i[first_name last_name] },
      genre_names: { relation: :genres, attributes: :name },
      keyword_names: { relation: :keywords, attributes: :name }
    )
  end
end
