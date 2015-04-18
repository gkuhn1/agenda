require 'rails_helper'

class SomeBogusClass; end

RSpec.describe ApplicationController, type: :controller do

  context "#admin_required!" do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) {
      allow(controller).to receive(:current_user).and_return(user)
    }

    it "should raise AdminRequiredException if current_user isn't admin" do
      user.admin = false
      expect { controller.admin_required! }.to raise_error(AdminRequiredException)
    end

    it "should not raise AdminRequiredException if current_user is admin" do
      user.admin = true
      expect { controller.admin_required! }.not_to raise_error
    end
  end

  context "#not_found" do
    controller(ApplicationController) do
      skip_before_filter :authenticate, :account_required, :user_required, only: :index
      def index
        raise Mongoid::Errors::DocumentNotFound.new(SomeBogusClass, {})
      end
    end
    it "should render not found with code 404" do
      get :index
      expect(response.code).to eq('404')
      expect(response.body).to eq({:error => 'Not Found'}.to_json)
    end
  end

  context "#unprocessable_entity" do
    controller(ApplicationController) do
      skip_before_filter :authenticate, :account_required, :user_required, only: :create
      def create
        params.require(:task).permit(:id, :title, :description, :where, :start_at, :end_at)
      end
    end

    it "should return 422 if task is empty" do
      post :create, {:task => {}}
      expect(response.code).to eq('422')
      expect(response.body).to eq({:error => 'Unprocessable Entity'}.to_json)
    end
    it "should return 422 if task is not informed" do
      post :create, {}
      expect(response.code).to eq('422')
      expect(response.body).to eq({:error => 'Unprocessable Entity'}.to_json)
    end
  end

end