require 'sidekiq'
require 'sidekiq-cron'

if Sidekiq.server?
  schedule_file = Rails.root.join('config', 'sidekiq.yml')

  if File.exist?(schedule_file)
    schedule_data = YAML.load_file(schedule_file)
    if schedule_data['schedule']
      Sidekiq::Cron::Job.load_from_hash(schedule_data['schedule'])
      Rails.logger.info "✅ Sidekiq cron schedule loaded successfully."
    else
      Rails.logger.warn "⚠️ No 'schedule' key found in #{schedule_file}."
    end
  else
    Rails.logger.warn "⚠️ Schedule file #{schedule_file} not found."
  end
end
