class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :define_userstamps_current, :check_for_admin

  protected

  # Set userstamp for any database updates to the current user
  def define_userstamps_current
    Mongoid::Userstamps::Config.set_current(current_user) if current_user
  end

  # Make the first user an admin
  def check_for_admin
    if current_user && User.first == User.last
      unless current_user.has_role? :admin
        current_user.add_role :admin
      end
    end
  end
end
