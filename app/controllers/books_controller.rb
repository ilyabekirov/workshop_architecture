class BooksController < ApplicationController
  def index
    items_per_page = Settings.app.items_per_page

    page = params[:page]&.to_i&.positive? ? params[:page].to_i : 1
    books = Book.search(
      "*",
      page: page,
      per_page: items_per_page,
      load: true
    ).to_a

    render json: BookSerializer.new(books).serialize
  end
end
