require 'facebook/messenger/configuration/providers/base'

module Facebook
  module Messenger
    class Configuration
      module Providers
        # The default configuration provider for environment variables.
        class Environment < Base
          def valid_verify_token?(verify_token)
            verify_token == Rails.application.credentials.verify_token
          end
        end
      end
    end
  end
end
