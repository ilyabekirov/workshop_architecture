module RabbitMessages
  class Send < BaseAmqp
    include Logging

    attr_reader :details, :parsed_message

    def initialize(parsed_message, details)
      super()
      @details = details
      @parsed_message = parsed_message
    end

    def call
      initialize_rabbit_message!(parsed_message, RabbitMessage::OUTCOME_MESSAGE,
                                 parsed_message[:from])

      publish_exchange(payload_json)

      rabbit_message&.assign_attributes(data: payload_json)
    rescue => e
      log_error(e)
    ensure
      rabbit_message&.save
    end

    private

    def publish_exchange(payload)
      logging_message(payload)
      exchange = find_exchange(EXCHANGE)
      exchange.publish(payload.to_json, routing_key: parsed_message[:from])
    end

    def logging_message(payload)
      message = I18n.t('messages.answer_send', routing_key: parsed_message[:from], payload: payload)
      Rails.logger.info(message)
    end

    def payload_json
      {
        content_type: 'application/json',
        encoding: 'UTF-8',
        payload: payload_data,
        reply_to: Settings.app.name,
        timestamp: Time.now.to_i
      }
    end

    def payload_data
      {
        params: {
          initial_message: parsed_message,
          details: details
        }
      }
    end
  end
end
