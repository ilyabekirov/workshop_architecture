namespace :elasticsearch do
  desc "Reindex all books into Elasticsearch with batches"
  task reindex_books: :environment do
    Elasticsearch::ReindexBooksService.new.call
  end
end
