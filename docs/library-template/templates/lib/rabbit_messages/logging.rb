module RabbitMessages
  module Logging
    extend ActiveSupport::Concern

    included do
      attr_reader :rabbit_message
    end

    def initialize_rabbit_message!(
      data,
      direction = RabbitMessage::INCOME_MESSAGE,
      routing_key = Settings.sneakers.queue_from
    )
      @rabbit_message = RabbitMessage.create!(
        success: true,
        action: data[:action],
        routing_key: routing_key,
        data: data,
        direction: direction
      )
    end

    def failed_rabbit_message(exception)
      rabbit_message&.assign_attributes(
        error_backtrace: exception.backtrace.join("\n"),
        error_message: exception.message,
        success: false
      )
    end

    def log_error(err)
      return unless err

      message = I18n.t('errors.exception', error_class: err.class)
      Rails.logger.error(message)

      failed_rabbit_message(err)
    end
  end
end
