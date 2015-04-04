module ControllerMacros
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
end


def login_user(user=nil, account=nil)
  @request.env["devise.mapping"] = Devise.mappings[:user]
  @user = user || FactoryGirl.create(:user)
  sign_in @user
  session[:account_id] = account.id if account
end

def set_accept(accept = 'application/json')
  request.env['ACCEPT'] = accept
end