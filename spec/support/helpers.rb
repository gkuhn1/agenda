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

def api_authenticate(user, account)
  env = {}
  env['HTTP_ACCEPT'] = "application/json"
  env['CONTENT_TYPE'] = "application/json"
  env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.try(:token) || "", account.try(:id) || "")
  env
end

def set_accept(accept = 'application/json')
  request.env['ACCEPT'] = accept
end

SUCCESS_STATUS_ACTIONS = {
  index: "200",
  show: "200",
  new: "200",
  create: "201",
  edit: "200",
  update: "200",
  destroy: "204",
}

def success_status_for_action(action)
  SUCCESS_STATUS_ACTIONS[action.to_sym]
end

METHOD_ACTIONS = {
  index: :get,
  show: :get,
  new: :get,
  create: :post,
  edit: :get,
  update: :post,
  destroy: :delete,
}

def method_for_action(action)
  METHOD_ACTIONS[action.to_sym]
end