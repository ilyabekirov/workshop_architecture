class SneakersListener
  include Sneakers::Worker
  include RabbitMessages::Logging

  VALID_ACTIONS = %w[
    like
  ].freeze
  QUEUE_NAME = Settings.sneakers.queue
  PG_EXCEPTION = [
    ActiveRecord::ConnectionNotEstablished,
    ActiveRecord::ConnectionTimeoutError,
    ActiveRecord::NoDatabaseError,
    ActiveRecord::StatementInvalid,
    PG::ConnectionBad,
    PG::UnableToSend
  ].freeze

  from_queue Settings.sneakers.queue

  attr_reader :parsed_message

  def work(message)
    parse_message(message)
    ActiveRecord::Base.connection_pool.with_connection { process_message }
    ack!
  rescue *PG_EXCEPTION => e
    reconnect_to_database(e)
  rescue StandardError => e
    log_error(e)
    reject!
  end

  private

  def parse_message(message)
    @parsed_message = JSON.parse(message, symbolize_names: true)
    logger.info("Listener worker - message: #{parsed_message}")
  end

  def process_message
    initialize_rabbit_message!(parsed_message)
    if VALID_ACTIONS.include?(action)
      send(action, parsed_message)
    else
      logger.error("Listener worker - unknown action: #{action}")
    end
    rabbit_message.update!(success: true)
  end

  def like(message)
    logger.info('###################################################')
    logger.info('## TODO like')
    logger.info('###################################################')
    details = { todo: 'Ответа сервиса' }
    RabbitMessages::Send.new(message, details).call
  end

  def action
    parsed_message[:action]
  end

  def reconnect_to_database(err)
    log_error(err)
    sleep(10)
    ActiveRecord::Base.connection.reconnect!
    requeue!
  rescue StandardError => e
    reconnect_to_database(e)
  end
end
