namespace :fake_message do
  desc 'Тестовое сообщение'
  task start: :environment do
    json_path = Rails.root.join('spec', 'fixtures', 'like.json').to_path
    message = JSON.parse(File.read(json_path))
    p message
    p Settings.rabbitmq.to_h
    connection = Bunny.new(Settings.rabbitmq.to_hash).start
    channel = connection.create_channel
    exchange = channel.topic('services', durable: true)
    exchange.publish(message.to_json, routing_key: Settings.sneakers.queue)
    connection.close
  end
end
