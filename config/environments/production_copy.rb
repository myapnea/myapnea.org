=begin
    bundle exec rake db:drop RAILS_ENV=production_copy
    bundle exec rake db:create RAILS_ENV=production_copy
    psql -U postgres -d myapnea_production_copy -f /home/pwm4/dumps/myapnea_production-20150305-1300.sql
    bundle exec rake db:migrate RAILS_ENV=production_copy
    bundle exec rake surveys:refresh RAILS_ENV=production_copy
    bundle exec rake surveys:load["about-me"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["about-my-family"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["additional-information-about-me"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["my-sleep-pattern"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["my-sleep-quality"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["my-health-conditions"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["my-interest-in-research"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["my-quality-of-life"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["my-sleep-apnea-treatment"] RAILS_ENV=production_copy
    bundle exec rake surveys:load["my-sleep-apnea"] RAILS_ENV=production_copy
=end

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = false

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Set the relative root, if it exists
  config.action_controller.relative_url_root  = URI.parse(ENV['website_url']).path rescue nil
end
