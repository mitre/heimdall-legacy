module ValidUserRequestHelper
  # for use in request specs
  def sign_in_as_a_valid_user
    @user ||= FactoryBot.create :editor
    post '/db_users/sign_in', params: { db_user: { email: @user.email, password: @user.password, password_confirmation: @user.password, commit: 'Log in' } }
  end
end

RSpec.configure do |config|
  config.include ValidUserRequestHelper, type: :request
end
