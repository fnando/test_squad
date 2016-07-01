module Dummy
  class Application < Rails::Application
    config.active_support.test_order = :random
    config.secret_token = SecureRandom.hex(100)
    config.secret_key_base = SecureRandom.hex(100)
    config.eager_load = false
  end
end

Dummy::Application.initialize!
