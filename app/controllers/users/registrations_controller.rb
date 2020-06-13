module Users

  class RegistrationsController < Devise::RegistrationsController
    def create
      #if Settings.local_login.enabled
        super

      #else
        #redirect_back(fallback_location: new_user_session_path, alert: I18n.t('devise.registrations.disabled'))
      #end
    end
  end
end
