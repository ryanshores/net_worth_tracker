class DashboardController < ApplicationController
  def index
    @institutions = Institution.all
  end
end
