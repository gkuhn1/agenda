RSpec.shared_examples "require current_user" do

  let(:action) { :index }
  let(:extra_params) { {} }

  let(:method) { method_for_action(action) }
  let(:success_status) { success_status_for_action(action) }

  let!(:account) { FactoryGirl.create(:account) }
  let!(:user) { account.users.first }

  let!(:auth_params)              { { format: 'json', user_email: user.email, user_token: user.token, user_account: account.id} }

  let(:auth_params_no_email)      { { format: 'json', user_token: user.token, user_account: account.id} }
  let(:auth_params_no_token)      { { format: 'json', user_email: user.email, user_account: account.id} }
  let(:auth_params_invalid_token) { { format: 'json', user_email: user.email, user_token: "user.token", user_account: account.id} }
  let(:auth_params_invalid_email) { { format: 'json', user_email: "user.email", user_token: user.token, user_account: account.id} }

  context "with current_user" do
    it "should return success_status if success" do
      self.send(method, action, auth_params.merge(extra_params))
      expect(response.code).to eq(success_status)
    end
  end

  context "without user_email" do
    it "should return 401 error" do
      self.send(method, action, auth_params_no_email.merge(extra_params) )
      expect(response.code).to eq("401")
      expect(response.body).to eq({error: "Unauthorized"}.to_json)
    end
  end

  context "without user_token" do
    it "should return 401 error" do
      self.send(method, action, auth_params_no_token.merge(extra_params) )
      expect(response.code).to eq("401")
      expect(response.body).to eq({error: "Unauthorized"}.to_json)
    end
  end

  context "without valid user_token" do
    it "should return 401 error" do
      self.send(method, action, auth_params_invalid_token.merge(extra_params) )
      expect(response.code).to eq("401")
      expect(response.body).to eq({error: "Unauthorized"}.to_json)
    end
  end

  context "without valid user_email" do
    it "should return 401 error" do
      self.send(method, action, auth_params_invalid_email.merge(extra_params) )
      expect(response.code).to eq("404")
      expect(response.body).to eq({error: "Not Found"}.to_json)
    end
  end

end