class DashboardController < ApplicationController
  def index
    @institutions = Institution.all
    @time_series = NetWorthService.time_series
  end
end
