require 'rails_helper'

class MockIndexController
  include Index

  def controller_name
    "users"
  end
end

describe Index, type: :controller do

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
            resources :users, only: [:index]
          end
        end
      }
    end

    it "should return all users from current_account" do
      FactoryGirl.create(:user)
      FactoryGirl.create(:user)
      account.add_user(FactoryGirl.create(:user))
      get :index, auth_params
      expect(assigns(:users)).to eq(account.users)
    end
  end

  context "custom_order" do
    it "should accept an collection and return a collection ordered" do
      controller = MockIndexController.new
      collection = controller.send(:custom_order, User)
      expect(collection.options).to eq({:sort=>{"created_at"=>1}})
    end
  end

  context "get_variable" do
    it "should return controller_name.singularize" do
      controller = MockIndexController.new
      expect(controller.send(:get_variable)).to eq("@user")
    end
  end

  context "get_variable_plural" do
    it "should return controller_name.pluralize" do
      controller = MockIndexController.new
      expect(controller.send(:get_variable_plural)).to eq("@users")
    end
  end

  context "get_model" do
    it "should return controller's model" do
      controller = MockIndexController.new
      expect(controller.send(:get_model)).to eq(User)
    end
    it "should return nil if model not finded" do
      controller = MockIndexController.new
      allow(controller).to receive(:controller_name).and_return('users1')
      expect(controller.send(:get_model)).to eq(nil)
    end
  end

  context "get_collection" do
    it "should return a collection" do
      controller = MockIndexController.new
      expect(controller).to receive(:get_model).and_return(User)
      expect(controller.send(:get_collection)).to eq(User)
    end

    it "should return nil if get_model returned nil" do
      controller = MockIndexController.new
      allow(controller).to receive(:controller_name).and_return('users1')
      expect(controller.send(:get_collection)).to eq(nil)
    end
  end

end
