class PullBalancesJob < ApplicationJob
  queue_as :default

  Institution.find_each do |institution|
    institution.needs_auth?
  end
  def perform(*args)
    Institution.ok.find_each do |institution|
      Institutions::PullBalances.call(institution)
    end
  end
end
