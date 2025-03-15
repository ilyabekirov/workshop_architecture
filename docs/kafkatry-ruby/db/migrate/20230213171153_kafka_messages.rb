class KafkaMessages < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'

    create_table(
      :kafka_messages,
      id: :uuid,
      default: -> { 'gen_random_uuid()' },
      comment: 'Отобранные Kafka-сообщения',
      force: :cascade
    ) do |t|
      t.string :action, null: false, comment: 'Тип/экшен сообщения'
      t.jsonb  :data, comment: 'Структура сообщения, которая будет передаваться следующему микросервису'
      t.string :direction, default: 'income', comment: 'Направление сообщения'

      t.timestamps
    end

    add_index :kafka_messages, :action
  end
end
