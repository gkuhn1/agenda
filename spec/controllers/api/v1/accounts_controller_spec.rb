require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do

  it_behaves_like "api v1 controller" do
    let(:action) {:current}
  end

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:account2) { FactoryGirl.create(:account, user: user) }
  let(:account3) { FactoryGirl.create(:account) }
  let(:auth_params) { {format: 'json', user_email: user.email, user_token: user.token, user_account: account.id} }

  context "#index" do
    it "should return all accounts from current_user" do
      [account2, account3]
      get :index, auth_params
      expect(response.code).to eq("200")
      expect(assigns(:accounts).count).to eq(2)
    end

    it_behaves_like "require current_account" do
      let(:action) {:index}
    end

    it_behaves_like "require current_user" do
      let(:action) {:index}
    end

  end

  context "#show" do
    it_behaves_like "require current_account" do
      let(:action) {:show}
      let(:extra_params) { {id: account.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:show}
      let(:extra_params) { {id: account.id} }
    end
  end

  context "#create" do
    let(:auth_params_no_account) { {format: 'json', user_email: user.email, user_token: user.token} }
    let(:account_params) { {account: FactoryGirl.attributes_for(:account).merge(user_ids: [user.id])} }

    it "should not require current_account" do
      post :create, auth_params_no_account.merge(account_params)
      expect(response.code).to eq("201")
    end

    it_behaves_like "require current_user" do
      let(:action) {:create}
      let(:extra_params) { account_params }
    end
  end

  context "#update" do
    it "should require an current account" do
    end
    it "should require an current user" do
    end
  end

  context "#current" do
    it "@account should be current_account" do
    end
  end

end
