# == Schema Information
#
# Table name: kafka_messages
#
#  id         :uuid             not null, primary key
#  action     :string           not null
#  data       :jsonb
#  direction  :string           default("income")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_kafka_messages_on_action  (action)
#
class KafkaMessage < ApplicationRecord
  INCOME_MESSAGE = 'income'.freeze
  OUTCOME_MESSAGE = 'outcome'.freeze

  validates :action, presence: true
end
