namespace :karafka do
  namespace :producer do
    desc 'Отправка уведомления в топик example'
    task produce_sync: :environment do
      Karafka.producer.produce_sync(topic: 'example', payload: { 'ping' => "pong at #{Time.current.to_i}" }.to_json)
    end
  end
end
