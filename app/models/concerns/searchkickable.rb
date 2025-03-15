module Searchkickable
  extend ActiveSupport::Concern

  SETTINGS = {
    analysis: {
      analyzer: {
        searchkick_search: {
          type: "custom",
          tokenizer: "standard",
          filter: %w[lowercase snowball]
        },
        searchkick_search2: {
          type: "custom",
          tokenizer: "standard",
          filter: %w[lowercase snowball]
        }
      }
    }
  }.freeze

  TEXT_FIELD_MAPPING = {
    type: "text",
    fields: {
      analyzed: { type: "text", analyzer: "searchkick_search" },
      analyzed2: { type: "text", analyzer: "searchkick_search2" },
      keyword: { type: "keyword" }
    }
  }.freeze

  MAPPINGS = {
    properties: {
      title: TEXT_FIELD_MAPPING,
      libid: { type: "integer" },
      size: { type: "integer" },
      filename: { type: "integer" },
      folder_id: { type: "keyword" },
      language_id: { type: "keyword" },
      author_names: TEXT_FIELD_MAPPING,
      genre_names: TEXT_FIELD_MAPPING,
      keyword_names: TEXT_FIELD_MAPPING
    }
  }.freeze

  included do
    searchkick index_name: -> { Rails.env.production? ? "books_production" : "books" },
      settings: SETTINGS,
      mappings: MAPPINGS
  end
end
