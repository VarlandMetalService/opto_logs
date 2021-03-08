require_relative "boot"

# require "rails/all"

require "rails"

# Include each railties manually, excluding `active_storage/engine`
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module OptoLogs
  class Application < Rails::Application

    config.load_defaults 6.1

    config.active_job.queue_adapter = :sidekiq
    
    config.time_zone = 'Eastern Time (US & Canada)'
    config.active_record.default_timezone = :local

  end
end