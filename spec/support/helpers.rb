module ControllerMacros
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
end

# def mock_database(database=Mongoid.default_database)
#   before(:each) do
#     allow(Mongoid).to receive(:current_database) { database }
#   end
# end

# def switch_database(account)
#   Mongoid.set_current_database(account.database)
# end

# def clear_database
#   Mongoid.destroy_current_database
# end

def api_authenticate(user=nil, account=nil)
  set_content_type()
  @request.headers['AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.try(:token) || "", account.try(:id) || "") if user and account
end

def set_accept(accept = 'application/json')
  @request.headers['ACCEPT'] = accept
end

def set_content_type(ct = 'application/json')
  @request.headers['CONTENT_TYPE'] = ct
  @request.headers['ACCEPT'] = ct
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