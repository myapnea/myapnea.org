# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in gems.rb, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyApnea
  # Provides framework for the MyApnea study surveys, and a member forum.
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # TODO: Remove this line and make :zeitwerk work with module loading dependencies.
    config.autoloader = :classic # :zeitwerk

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rails time:zones" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Eastern Time (US & Canada)"

    # Ignores custom error DOM elements created by Rails.
    config.action_view.field_error_proc = proc { |html_tag, _instance| html_tag }

    # Add Model subfolders to autoload_paths
    # config.autoload_paths += Dir[Rails.root.join("app", "models", "{**/}")]
    config.autoload_paths << Rails.root.join("app", "models", "admin")

    # Add Slice models to autoload_paths.
    config.autoload_paths << Rails.root.join("app", "models", "slice")
  end
end
