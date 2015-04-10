require 'rails_helper'

describe Destroy, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:auth_params) { {} }

  context "#action" do

    controller(Api::V1::UsersController) do
    end

    before :each do
      auth_params
      routes.draw {
        namespace :api do
          namespace :v1 do
            resources :users, only: [:destroy]
          end
        end
      }
    end

    before(:each) do
      api_authenticate(user, account)
    end

    it "should return all users from current_account" do
      user2 = FactoryGirl.create(:user)
      account.add_user(user2)

      expect { delete :destroy, auth_params.merge(id: user2.id) }.to change(User, :count).by(-1)
      expect(response.code).to eq("204")
    end
  end

end
