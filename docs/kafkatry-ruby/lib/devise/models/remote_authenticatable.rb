module Devise
  module Models
    module RemoteAuthenticatable
      extend ActiveSupport::Concern

      included do
        def self.remote_authentication(authentication_hash)
          response = check_remote_data(authentication_hash)
          return nil unless response

          decoded_token = JsonWebToken.decode(response.dig('result', 'token'))
          return nil if decoded_token.nil?

          AdminUser.new(decoded_token)
        end

        def self.check_remote_data(authentication_hash)
          inbox_client.auth(body: params_for_auth(authentication_hash))
        rescue MortgageClients::Http::UnauthorizedRequest
          nil
        end

        def self.inbox_client
          @inbox_client ||= MortgageClients::Http::InboxAlfa.new(
            Settings.hosts.inbox_alfa, verify: false
          )
        end

        def self.params_for_auth(authentication_hash)
          {
            auth: {
              login: authentication_hash[:login],
              password: authentication_hash[:password]
            }
          }
        end
      end

      class_methods do
        # rubocop:disable Style/RedundantSelf
        def serialize_from_session(id, role, email, login, name)
          resource = self.new
          resource.id     = id
          resource.role   = role
          resource.email  = email
          resource.login  = login
          resource.name   = name
          resource
        end
        # rubocop:enable Style/RedundantSelf

        def serialize_into_session(record)
          [
            record.id,
            record.role,
            record.email,
            record.name,
            record.login
          ]
        end
      end
    end
  end
end
