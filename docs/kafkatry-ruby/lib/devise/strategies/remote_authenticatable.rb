require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class RemoteAuthenticatable < Authenticatable
      def authenticate!
        # authentication_hash doesn't include the password
        auth_params = authentication_hash.merge(password: password)
        # mapping.to is a wrapper over the resource model
        user = mapping.to.remote_authentication(auth_params)
        return fail! if user.nil?
        return fail! unless user.role.in?(%w[admin bank_admin])

        success!(user)
      end
    end
  end
end
