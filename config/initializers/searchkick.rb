require 'elasticsearch'

Searchkick.client = Elasticsearch::Client.new(
  hosts: ENV["ELASTICSEARCH_URL"] || "http://localhost:9200"
)
