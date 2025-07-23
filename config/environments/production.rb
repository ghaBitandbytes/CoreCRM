require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Enable fragment caching.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  # Store uploaded files on the local file system (change to :amazon for S3).
  config.active_storage.service = :local

  # Assume all access is happening through an SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access over SSL and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for health check.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Use tagged logging.
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  # Set logging level.
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Ignore health check logs.
  config.silence_healthcheck_path = "/up"

  # Don’t log deprecations.
  config.active_support.report_deprecations = false

  # Use memory store for cache or replace with Memcached/Redis if needed.
  config.cache_store = :solid_cache_store

  # ActiveJob queue adapter for background jobs.
  config.active_job.queue_adapter = :sidekiq

  # Action Mailer configuration (SendGrid example)
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {
    host: "https://core-crm.onrender.com" # Replace with your domain if available
  }
  config.action_mailer.default_options = {
    from: "ghaziah053@gmail.com"
  }
  config.action_mailer.smtp_settings = {
    user_name: ENV["SMTP_USERNAME"],        # e.g., "apikey" for SendGrid
    password: ENV["SMTP_PASSWORD"],         # Your actual API key
    domain: "core-crm.onrender.com",        # Or your custom domain
    address: "smtp.sendgrid.net",           # For SendGrid
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

  # Fallbacks for missing translations.
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for object inspection in logs.
  config.active_record.attributes_forinspect = [:id]

  # Optional: Allow specific hosts (Uncomment if needed)
  # config.hosts << "core-crm.onrender.com"

  # Optional: Skip host header protection for health check
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
