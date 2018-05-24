class DashboardController < ApplicationController
  def index
    session[:filter] = nil
  end
end
