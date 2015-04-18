RSpec.shared_examples "require current_user" do

  let(:action) { :index }
  let(:extra_params) { {} }

  let(:method) { method_for_action(action) }
  let(:success_status) { success_status_for_action(action) }

  let(:account) { @account || FactoryGirl.create(:account) }
  let(:user) { @user || account.users.first }

  context "with current_user" do
    it "should return success_status if success" do
      api_authenticate(user, account)
      self.send(method, action, extra_params)
      expect(response.code).to eq(success_status)
    end
  end

  context "without user_token" do
    it "should return 401 error" do
      user.token = nil
      api_authenticate(user, account)
      self.send(method, action, extra_params)
      expect(response.code).to eq("401")
      expect(response.body).to eq({error: "Unauthorized"}.to_json)
    end
  end

  context "without valid user_token" do
    it "should return 401 error" do
      @request.headers['AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("user.token", account.id)
      self.send(method, action, extra_params)
      expect(response.code).to eq("401")
      expect(response.body).to eq({error: "Unauthorized"}.to_json)
    end
  end

end