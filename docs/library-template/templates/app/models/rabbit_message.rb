class RabbitMessage < ApplicationRecord
  include Ransackable

  INCOME_MESSAGE = 'income'.freeze
  OUTCOME_MESSAGE = 'outcome'.freeze
  DIRECTIONS = [INCOME_MESSAGE, OUTCOME_MESSAGE].freeze

  enum :direction, DIRECTIONS.index_by(&:to_sym)

  validates :action, presence: true
  validates :direction, inclusion: { in: DIRECTIONS }

  PUBLIC_FIELDS = %w[id direction action routing_key success error_message created_at updated_at]
  RANSACK_ASSOCIATIONS = %w[id direction action routing_key success error_message created_at updated_at]
end
