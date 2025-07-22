require_relative 'boot'

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Corecrm
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Use Sidekiq as ActiveJob backend
    config.active_job.queue_adapter = :sidekiq

    # Load lib/ but ignore specified subfolders
    config.autoload_lib(ignore: %w[assets tasks])

    # Set application time zone
    config.time_zone = 'Asia/Karachi'
    config.active_record.default_timezone = :utc

    # Optional: eager load paths for jobs/mailers/etc.
    # config.eager_load_paths << Rails.root.join("extras")

    # Sidekiq Redis configuration (make sure ENV['REDIS_URL'] is set in your .env file)
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/1' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/1' }
    end
  end
end
