require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }

  schedule_file = "config/sidekiq.yml"
  if File.exist?(schedule_file)
    yaml_data = YAML.load_file(schedule_file)
    if yaml_data['schedule']
      Sidekiq::Cron::Job.load_from_hash(yaml_data['schedule'])
      Rails.logger.info("✅ Sidekiq schedule loaded from #{schedule_file}")
    else
      Rails.logger.warn("⚠️ No 'schedule' key found in #{schedule_file}")
    end
  else
    Rails.logger.warn("⚠️ Schedule file #{schedule_file} not found")
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
