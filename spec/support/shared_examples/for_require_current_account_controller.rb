RSpec.shared_examples "require current_account" do

  let(:action) { :index }
  let(:extra_params) { {} }

  let(:method) { method_for_action(action) }
  let(:success_status) { success_status_for_action(action) }

  let(:account) { @account || FactoryGirl.create(:account) }
  let(:user) { @user || account.users.first }
  let(:user2) { FactoryGirl.create(:user) }
  let(:account2) { FactoryGirl.create(:account) }

  context "with current_account" do
    it "should return success_status if success" do
      api_authenticate(user, account)
      self.send(method, action, extra_params)
      expect(response.code).to eq(success_status)
    end
  end

  context "without current_account" do
    it "should return 401 error" do
      api_authenticate(user, nil)
      self.send(method, action, extra_params)
      expect(response.code).to eq("401")
      expect(response.body).to eq({error: "Unauthorized"}.to_json)
    end
  end

  context "without valid account" do
    it "should return 401 error" do
      account.id = '123123'
      api_authenticate(user, account)
      self.send(method, action, extra_params )
      expect(response.code).to eq("401")
      expect(response.body).to eq({error: "Unauthorized"}.to_json)
    end
  end

  context "with other user valid account" do
    it "should return 401 error" do
      api_authenticate(user2, account)
      self.send(method, action, extra_params)
      expect(response.code).to eq("401")
      expect(response.body).to eq({error: "Unauthorized"}.to_json)
    end
  end

end