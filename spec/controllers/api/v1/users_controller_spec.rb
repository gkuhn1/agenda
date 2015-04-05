require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  it_behaves_like "api v1 controller"

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:user2) { FactoryGirl.create(:user) }
  let(:user3) { FactoryGirl.create(:user) }
  let(:auth_params) { {format: 'json', user_email: user.email, user_token: user.token, user_account: account.id} }

  context "#index" do
    it "should return all users from current_account" do
      [user, user2, user3]
      account.add_user(user3)

      get :index, auth_params
      expect(assigns(:users).count).to eq(2)
      expect(assigns(:users)).to match_array([user, user3])
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
      let(:extra_params) { {id: user.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:show}
      let(:extra_params) { {id: user.id} }
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
    let(:user_params) { {user: FactoryGirl.attributes_for(:user).merge(account_ids: [account.id])} }

    it_behaves_like "require current_account" do
      let(:action) {:create}
      let(:extra_params) { user_params }
    end

    it_behaves_like "require current_user" do
      let(:action) {:create}
      let(:extra_params) { user_params }
    end
  end

  context "#edit" do
    it_behaves_like "require current_account" do
      let(:action) {:edit}
      let(:extra_params) { {id: user.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:edit}
      let(:extra_params) { {id: user.id} }
    end
  end

  context "#update" do
    let(:user_params) { {id: user.id, user: FactoryGirl.attributes_for(:user).merge(account_ids: [account.id])} }

    it_behaves_like "require current_account" do
      let(:action) {:update}
      let(:extra_params) { user_params }
    end

    it_behaves_like "require current_user" do
      let(:action) {:update}
      let(:extra_params) { user_params }
    end
  end

  context "#destroy" do
    it_behaves_like "require current_account" do
      let(:action) {:destroy}
      let(:extra_params) { {id: user.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:destroy}
      let(:extra_params) { {id: user.id} }
    end
  end

  context "#login" do
    let(:auth_params_no_account_and_user) { {format: 'json', email: user.email, password: "mypassword"} }

    it "should not require current_account nor current_user" do
      post :login, auth_params_no_account_and_user
      expect(response.code).to eq("200")
    end

    it "should return user informations if loggin_success" do
      post :login, auth_params_no_account_and_user
      expect(response.code).to eq("200")
      expect(assigns(:user)).not_to be(nil)
    end

    it "should return Dados inválidos error if emails does not exists" do
      post :login, auth_params_no_account_and_user.merge(email: "email_inexistente@user.com")
      expect(response.code).to eq("422")
      expect(response.body).to eq({error: "Dados inválidos"}.to_json)
    end

    it "should return Dados Inválidos error if password is incorrect" do
      post :login, auth_params_no_account_and_user.merge(password: "password_errado")
      expect(response.code).to eq("422")
      expect(response.body).to eq({error: "Dados inválidos"}.to_json)
    end

  end


  context "#current" do
    it "@user should be current_user" do
      get :current, auth_params
      expect(assigns(:user)).to eq(user)
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

end
