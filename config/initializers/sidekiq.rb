require "sidekiq"
require "sidekiq-cron"

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq::Cron::Job.create(
      name: "Daily balance pull",
      cron: "0 6 * * *", # every day at 6 am
      class: "PullBalancesJob"
    )
  end
end
