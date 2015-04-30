require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:n1) { FactoryGirl.create(:notification, user:user)}

  before(:each) {
    @account = account
    @user = user
  }

  it_behaves_like "api v1 controller"

  context "#index" do
    it_behaves_like "require current_account" do
      let(:action) {:index}
    end

    it_behaves_like "require current_user" do
      let(:action) {:index}
    end

  end

  context "#mark_as_read" do
    it_behaves_like "require current_account" do
      let(:action) {:mark_as_read}
      let(:method) {:put}
      let(:success_status) {'200'}
      let(:extra_params) { {id: n1.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:mark_as_read}
      let(:method) {:put}
      let(:success_status) {'200'}
      let(:extra_params) { {id: n1.id} }
    end
  end

  context "#mark_as_unread" do
    it_behaves_like "require current_account" do
      let(:action) {:mark_as_unread}
      let(:method) {:put}
      let(:success_status) {'200'}
      let(:extra_params) { {id: n1.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:mark_as_unread}
      let(:method) {:put}
      let(:success_status) {'200'}
      let(:extra_params) { {id: n1.id} }
    end
  end

end
