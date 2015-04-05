require 'rails_helper'

describe Show, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:auth_params) { {format: 'json', user_email: user.email, user_token: user.token, user_account: account.id} }

  context "#action" do

    controller(Api::V1::UsersController) do
    end

    before :each do
      auth_params
      routes.draw {
        namespace :api do
          namespace :v1 do
            resources :users, only: [:show]
          end
        end
      }
    end

    it "should return all users from current_account" do
      get :show, auth_params.merge(id: user.id)
      expect(assigns(:user)).to eq(user)
    end
  end

end
