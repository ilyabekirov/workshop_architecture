# rubocop:disable Metrics/BlockLength
ActiveAdmin.register KafkaMessage do
  menu priority: 1, label: proc { I18n.t('active_admin.kafka_messages') }

  actions :index, :show, :resend

  action_item(:edit, only: :show) do
    button_to I18n.t('active_admin.resend'), resend_admin_kafka_message_path(kafka_message)
  end

  config.sort_order = 'created_at_desc'

  filter :entity_id
  filter :action, as: :select,
                  collection: proc { KafkaMessage.select(:action).distinct.pluck(:action).sort }
  filter :success
  filter :direction, as: :select, collection: proc { %w[income outcome] }

  controller do
    def scoped_collection
      end_of_association_chain.select(
        :id,
        :direction,
        :action,
        :created_at,
        :updated_at
      )
    end
  end

  index do
    column :entity_id
    column :action
    column :direction
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :action
      row :direction
      row :created_at
      row :updated_at
      row :data do |message|
        div class: 'b-json__show', 'data-json': message.data.to_json
      end
    end
  end

  # member_action :resend, method: :post do
  #   resource.resend!
  #   redirect_to resource_path, notice: I18n.t('active_admin.resended')
  # end
end
# rubocop:enable Metrics/BlockLength
