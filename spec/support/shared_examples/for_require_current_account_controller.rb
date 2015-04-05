RSpec.shared_examples "require current_account" do

  let(:action) { :index }
  let(:extra_params) { {} }

  let(:method) { method_for_action(action) }
  let(:success_status) { success_status_for_action(action) }

  let!(:account) { FactoryGirl.create(:account) }
  let!(:user) { account.users.first }
  let!(:account2) { FactoryGirl.create(:account) }

  let!(:auth_params) { {format: 'json', user_email: user.email, user_token: user.token, user_account: account.id} }
  let!(:auth_params_no_account) { {format: 'json', user_email: user.email, user_token: user.token} }
  let!(:auth_params_invalid_account) { {format: 'json', user_email: user.email, user_token: user.token, user_account: "account.id"} }
  let!(:auth_params_other_user_account) { {format: 'json', user_email: user.email, user_token: user.token, user_account: account2.id} }

  context "with current_account" do
    it "should return success_status if success" do
      self.send(method, action, auth_params.merge(extra_params))
      expect(response.code).to eq(success_status)
    end
  end

  context "without current_account" do
    it "should return 404 error" do
      self.send(method, action, auth_params_no_account.merge(extra_params) )
      expect(response.code).to eq("404")
      expect(response.body).to eq({error: "Selecione uma conta antes de fazer alterações."}.to_json)
    end
  end

  context "without valid account" do
    it "should return 404 error" do
      self.send(method, action, auth_params_invalid_account.merge(extra_params) )
      expect(response.code).to eq("404")
      expect(response.body).to eq({error: "Not Found"}.to_json)
    end
  end

  context "with other user valid account" do
    it "should return 404 error" do
      self.send(method, action, auth_params_other_user_account.merge(extra_params) )
      expect(response.code).to eq("404")
      expect(response.body).to eq({error: "Selecione uma conta antes de fazer alterações."}.to_json)
    end
  end

end