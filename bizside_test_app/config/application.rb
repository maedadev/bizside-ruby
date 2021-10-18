require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BizsideTestApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.action_controller.action_on_unpermitted_parameters = :raise

    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local

    config.i18n.available_locales = [:en, :ja]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :ja

    config.action_view.field_error_proc = Proc.new {|html_error, instance| "#{html_error}".html_safe }
  end
end
