require 'securerandom'

class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render text: exception, status: 500
  end
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
  helper_method :current_user
  protect_from_forgery with: :exception
  before_action :define_userstamps_current, :check_for_admin, :check_api_key

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    else
      session[:user_id] = nil
      @current_user = nil
    end
  end

  protected

  # Set userstamp for any database updates to the current user
  def define_userstamps_current
    Mongoid::Userstamps::User.current = current_user
  end

  # Make the first user an admin
  def check_for_admin
    if current_user && User.first == User.last
      unless current_user.has_role? :admin
        current_user.add_role :admin
      end
    end
  end

  def check_api_key
    if current_user && current_user.api_key.nil?
      current_user.api_key = SecureRandom.urlsafe_base64
      current_user.save
    end
  end
end
