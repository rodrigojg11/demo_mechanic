require_relative "boot"

require "logger"
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module DemoMechanic
  class Application < Rails::Application
    config.load_defaults 7.2
    config.time_zone = "Central Time (US & Canada)"
    config.i18n.default_locale = :en
    config.assets.quiet = true
    config.active_job.queue_adapter = :solid_queue
    config.solid_queue.connects_to = { database: { writing: :queue } }
    config.cache_store = :solid_cache_store
  end
end
