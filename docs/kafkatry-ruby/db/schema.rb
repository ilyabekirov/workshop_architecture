# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_13_171153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "kafka_messages", id: :uuid, default: -> { "gen_random_uuid()" }, comment: "Отобранные Kafka-сообщения", force: :cascade do |t|
    t.string "action", null: false, comment: "Тип/экшен сообщения"
    t.jsonb "data", comment: "Структура сообщения, которая будет передаваться следующему микросервису"
    t.string "direction", default: "income", comment: "Направление сообщения"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action"], name: "index_kafka_messages_on_action"
  end

end
