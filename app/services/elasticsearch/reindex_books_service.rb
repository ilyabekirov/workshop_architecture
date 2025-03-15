module Elasticsearch
  class ReindexBooksService
    BATCH_SIZE = 1000
    SUCCESS_STATUS = 0
    FAILURE_STATUS = 1

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end

    def call
      log_info "Reindexing all books into Elasticsearch with batches..."
      check_elasticsearch_connection
      reindex_books
      log_info "Finished reindexing #{@indexed_count || 0} books."
      exit SUCCESS_STATUS
    rescue Faraday::ConnectionFailed => e
      log_error "Could not connect to Elasticsearch at #{ENV['ELASTICSEARCH_URL']}: #{e.message}"
      exit FAILURE_STATUS
    rescue StandardError => e
      log_error "Reindexing failed: #{e.message}"
      exit FAILURE_STATUS
    end

    private

    def check_elasticsearch_connection
      response = Searchkick.client.cluster.health
      log_info "Elasticsearch cluster health: #{response['status']}"
    end

    def reindex_books
      reset_index
      index_books_in_batches
    end

    def reset_index
      index = Book.searchkick_index
      index.delete if index.exists?
      log_info "Creating Elasticsearch index with searchkick settings..."
      index.create(settings: index.options[:settings], mappings: index.options[:mappings])
    end

    def index_books_in_batches
      @total_books = Book.count
      @indexed_count = 0

      log_info "Starting batch indexing of #{@total_books} books..."
      Book.find_in_batches(batch_size: BATCH_SIZE) do |books|
        Book.searchkick_index.import(books)
        @indexed_count += books.size
        log_progress
      end
    end

    def log_progress
      percentage = ((@indexed_count.to_f / @total_books) * 100).round(2)
      log_info "Indexed #{@indexed_count}/#{@total_books} books (#{percentage}%)"
    end

    def log_info(message)
      @logger.info(message)
    end

    def log_error(message)
      @logger.error(message)
    end
  end
end
