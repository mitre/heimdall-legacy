require 'securerandom'

class ApplicationController < ActionController::Base

  helper :all

  before_action :setup_navigation, :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  #private

  def setup_navigation
    @navigation = []
    #@navigation += helpers.base_navigation if current_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  #rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
  #  render text: exception, status: 500
  #3end

  #rescue_from CanCan::AccessDenied do |exception|
  #  redirect_to root_url, alert: exception.message
  #end

  helper_method :current_user

  protect_from_forgery with: :exception
  #puts(@current_user)

  #def current_user
  #  if session[:user_id]
  #    @current_user ||= User.find_by(id: session[:user_id])
  #    if @current_user
  #      unless @current_user.has_role?(:admin)
  #        if User.first == User.last
  #          @current_user.add_role :admin
  #        end
  #      end
  #      if @current_user.api_key.nil?
  #        @current_user.api_key = SecureRandom.urlsafe_base64
  #        @current_user.save
  #      end
  #      return @current_user
  #   end
  #  end
  #  session[:user_id] = nil
  #  @current_user = nil
  #end

end
