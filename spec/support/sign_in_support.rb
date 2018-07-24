module ValidUserRequestHelper
  # for use in request specs
  def sign_in_as_a_valid_user
    @user ||= FactoryBot.build :editor
    post '/db_users', params: { db_user: { email: @user.email, password: @user.password, password_confirmation: @user.password } }
  end
end

RSpec.configure do |config|
  config.include ValidUserRequestHelper, type: :request
end
