require 'rails_helper'

describe New, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:auth_params) { {} }

  context "#action" do

    controller(Api::V1::UsersController) do
      def new
        super
        render :show
      end
    end

    before :each do
      auth_params
      routes.draw {
        namespace :api do
          namespace :v1 do
            resources :users, only: [:new]
          end
        end
      }
    end

    before(:each) do
      api_authenticate(user, account)
    end

    it "should return all users from current_account" do
      get :new, auth_params
      expect(assigns(:user).new_record?).to be(true)
    end
  end

end
