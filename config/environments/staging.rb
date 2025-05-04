require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings.
  config.eager_load = true

  # Full error reports are disabled (staging behaves like production).
  config.consider_all_requests_local = false

  # Enable caching.
  config.action_controller.perform_caching = true

  # Cache assets with far-future expiry
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  # Use local disk for uploaded files in staging
  config.active_storage.service = :local

  # If your Nginx/ALB handles SSL termination, no need to force SSL
  config.assume_ssl = true
  config.force_ssl = false

  # Logging
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "debug") # debug for easier staging debugging

  config.silence_healthcheck_path = "/up"

  # Disable deprecation logging in staging
  config.active_support.report_deprecations = false

  # Use solid cache and queue backends if used in production
  config.cache_store = :solid_cache_store

  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Mailer settings
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = false # staging에서는 메일 실제 전송 방지

  config.action_mailer.default_url_options = {
    host: ENV.fetch("STAGING_HOST", "staging.sample-app.com")
  }

  config.action_mailer.smtp_settings = {
    user_name: ENV["SMTP_USERNAME"],
    password:  ENV["SMTP_PASSWORD"],
    address:   "smtp.example.com",
    port:      587,
    authentication: :plain
  }

  # I18n
  config.i18n.fallbacks = true

  # Schema settings
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
end
