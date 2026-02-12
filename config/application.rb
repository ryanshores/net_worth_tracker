require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NetWorthTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :sidekiq

    config.to_prepare do
      enc = Rails.application.config.active_record.encryption
      creds = Rails.application.credentials.dig(:active_record_encryption)

      if creds.present?
        enc.primary_key ||= creds[:primary_key] if creds.primary_key.present?
        enc.deterministic_key ||= creds[:deterministic_key] if creds.deterministic_key.present?
        enc.key_derivation_salt ||= creds[:key_derivation_salt] if creds.key_derivation_salt.present?
      end
    end
  end
end
