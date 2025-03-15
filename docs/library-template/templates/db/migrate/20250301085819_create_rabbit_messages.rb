class CreateRabbitMessages < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto'

    create_table(
      :rabbit_messages,
      id: :uuid,
      default: -> { 'gen_random_uuid()' },
      comment: 'Логгирование RabbitMQ-сообщений',
      force: :cascade
    ) do |t|
      t.string :action, null: false, comment: 'Тип/экшен сообщения'
      t.jsonb  :data, comment: 'Структура сообщения, которая будет передаваться следующему микросервису'
      t.boolean :success, default: true, null: false, comment: 'Сообщение обработалось?'
      t.string :error_message, comment: 'Сообщение об ошибке'
      t.text :error_backtrace, comment: 'Стектрейс ошибки'
      t.string :direction, default: 'income', comment: 'Направление сообщения'
      t.string :routing_key, comment: 'Ключ маршрутизации'

      t.timestamps
    end

    add_index :rabbit_messages, :created_at
    add_index :rabbit_messages, :action
  end
end
