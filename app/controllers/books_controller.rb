class BooksController < ApplicationController
  def index
    items_per_page = Settings.app.items_per_page

    page = params[:page]&.to_i&.positive? ? params[:page].to_i : 1
    books = Book.limit(items_per_page).offset((page - 1) * items_per_page)

    render json: BookSerializer.new(books).serialize
  end
end
