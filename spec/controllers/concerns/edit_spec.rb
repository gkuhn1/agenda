require 'rails_helper'

describe Edit, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:auth_params) { {} }

  context "#action" do

    controller(Api::V1::UsersController) do
      def edit
        super
        render :show
      end
    end

    before :each do
      auth_params
      routes.draw {
        namespace :api do
          namespace :v1 do
            resources :users, only: [:edit]
          end
        end
      }
    end

    before(:each) do
      api_authenticate(user, account)
    end

    it "should return all users from current_account" do
      get :edit, auth_params.merge(id: user.id)
      expect(assigns(:user)).to eq(user)
    end
  end

end
