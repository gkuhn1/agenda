require 'rails_helper'

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

end