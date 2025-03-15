module Elasticsearch
  class SearchDataFormatter
    def initialize(record)
      @record = record
    end

    def format(fields)
      fields.transform_values do |value|
        if value.is_a?(Hash)
          format_relation(value[:relation], value[:attributes])
        else
          @record.send(value)
        end
      end
    end

    private

    def format_relation(relation_name, attributes)
      relation = @record.send(relation_name)
      relation.pluck(*attributes).join(" ")
    end
  end
end
