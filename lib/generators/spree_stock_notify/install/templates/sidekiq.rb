Sidekiq.configure_server do |config|
  config.on(:startup) do
    begin
      schedule_file = "config/schedule.yml"

      if File.exist?(schedule_file)
        schedule = YAML.load_file(schedule_file)

        Sidekiq::Cron::Job.load_from_hash!(schedule, source: "schedule")
        puts "Loaded Sidekiq schedule from #{schedule_file}."
      else
        puts "No schedule file found at #{schedule_file}."
      end
    rescue => e
      puts "Error loading Sidekiq schedule: #{e.message}"
    end
  end
end
