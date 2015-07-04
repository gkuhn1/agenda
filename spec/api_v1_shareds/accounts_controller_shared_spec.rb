require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do

  it_behaves_like "api v1 controller"

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:account2) { FactoryGirl.create(:account, user: user) }
  let(:account3) { FactoryGirl.create(:account) }
  let(:auth_params) { {} }

  context "#index" do
    it "should return all accounts from current_user" do
      [account2, account3]
      api_authenticate(user, account)
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

  context "#new" do
    it_behaves_like "require current_account" do
      let(:action) {:new}
    end

    it_behaves_like "require current_user" do
      let(:action) {:new}
    end
  end

  context "#create" do
    let(:auth_params_no_account) { {} }
    let(:auth_params_no_user) { {} }
    let(:account_params) { {account: FactoryGirl.attributes_for(:account)} }

    it "should not require current_account" do
      api_authenticate
      post :create, auth_params_no_account.merge(account_params)
      expect(response.code).to eq("201")
    end

    it "should not require current_user" do
      api_authenticate
      post :create, auth_params_no_user.merge(account_params)
      expect(response.code).to eq("201")
    end

    context "with user_attributes presents" do

      it "should create an user if user_attributes is present" do
        api_authenticate
        account_params = {account: FactoryGirl.attributes_for(:account).merge(user_attributes: FactoryGirl.attributes_for(:user))}
        expect{ post :create, account_params }.to change(User, :count).by(1) and change(Account, :count).by(1)
      end

      it "should return errors if user_attributes has errors" do
        api_authenticate
        account_params = {account: FactoryGirl.attributes_for(:account) }
        account_params[:account][:user_attributes] = {name: ""}
        post :create, account_params
        expect(assigns(:account).errors.to_h).to eq({
          :user_email=>"não pode ficar em branco",
          :user_password=>"não pode ficar em branco",
          :user_name=>"não pode ficar em branco"})
      end

    end

  end

  context "#edit" do
    it_behaves_like "require current_account" do
      let(:action) {:edit}
      let(:extra_params) { {id: account.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:edit}
      let(:extra_params) { {id: account.id} }
    end
  end


  context "#update" do

    let(:account_params) { {id: account.id, account: FactoryGirl.attributes_for(:account, name: "Novo nome").merge(user_ids: [user.id])} }

    it_behaves_like "require current_account" do
      let(:action) {:update}
      let(:extra_params) { account_params }
    end

    it_behaves_like "require current_user" do
      let(:action) {:update}
      let(:extra_params) { account_params }
    end
  end

  context "#destroy" do
    it_behaves_like "require current_account" do
      let(:action) {:destroy}
      let(:extra_params) { {id: account.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:destroy}
      let(:extra_params) { {id: account.id} }
    end
  end

  context "#current" do
    it "@account should be current_account" do
      api_authenticate(user, account)
      get :current, auth_params
      expect(assigns(:account)).to eq(account)
    end

    it_behaves_like "require current_account" do
      let(:action) {:current}
      let(:method) {:get}
      let(:success_status) {"200"}
    end

    it_behaves_like "require current_user" do
      let(:action) {:current}
      let(:method) {:get}
      let(:success_status) {"200"}
    end
  end

  context "#add_user" do
    let!(:user3) { FactoryGirl.create(:user) }

    it_behaves_like "require current_account" do
      let(:action) {:add_user}
      let(:method) {:post}
      let(:extra_params) { {user: {user_id: user3.id}} }
      let(:success_status) {"200"}
    end

    it_behaves_like "require current_user" do
      let(:action) {:add_user}
      let(:method) {:post}
      let(:extra_params) { {user: {user_id: user3.id}} }
      let(:success_status) {"200"}
    end
  end

  context "#remove_user" do
    let!(:user3) { FactoryGirl.create(:user) }

    before(:each) {
      account.add_user(user3)
    }
    it_behaves_like "require current_account" do
      let(:action) {:remove_user}
      let(:method) {:delete}
      let(:extra_params) { {user_id: user3.id} }
      let(:success_status) {"204"}
    end

    it_behaves_like "require current_user" do
      let(:action) {:remove_user}
      let(:method) {:delete}
      let(:extra_params) { {user_id: user3.id} }
      let(:success_status) {"204"}
    end
  end

end
