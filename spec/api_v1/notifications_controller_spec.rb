require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }

  before(:each) {
    api_authenticate(user, account)
  }

  context "index" do
    render_views
    let!(:n1) { FactoryGirl.create(:notification, type: 1, user:user) }
    let!(:n2) { FactoryGirl.create(:notification, type: 1, user:user) }
    let!(:n3) { FactoryGirl.create(:notification_read, type: 1, user:user) }
    let!(:n4) { FactoryGirl.create(:notification_read, type: 1, user:user) }
    let!(:n5) { FactoryGirl.create(:notification_read, type: 2, user:user) }
    let!(:n6) { FactoryGirl.create(:notification, type: 2, user:user) }

    it "should list all unread system notifications from current_user" do
      get :index
      expect(assigns(:reads).count).to eq(2)
      expect(assigns(:unreads).count).to eq(2)
      expect(assigns(:notifications).count).to eq(4)
    end
    it "should return a count of read notifications" do
      get :index
      expect(JSON.parse(response.body)["read_count"]).to eq(2)
    end
    it "should return a count of unread notifications" do
      get :index
      expect(JSON.parse(response.body)["unread_count"]).to eq(2)
    end
  end


  context "mark_as_read" do
    let(:user2) { FactoryGirl.create(:user) }
    let!(:n1) { FactoryGirl.create(:notification, type: 1, user:user) }
    let!(:n2) { FactoryGirl.create(:notification, type: 1, user:user2) }

    it "should mark a user notification as read" do
      put :mark_as_read, id: n1.id
      expect(assigns(:notification).read).to be true
    end
    it "should return 404 if notification is from other user" do
      put :mark_as_read, id: n2.id
      expect(response.code).to eq '404'
    end
    it "should return 404 if notification does not exists" do
      put :mark_as_read, id: "another-id"
      expect(response.code).to eq '404'
    end
  end


  context "mark_as_unread" do
    let(:user2) { FactoryGirl.create(:user) }
    let!(:n1) { FactoryGirl.create(:notification_read, type: 1, user:user) }
    let!(:n2) { FactoryGirl.create(:notification_read, type: 1, user:user2) }

    it "should mark a user notification as unread" do
      put :mark_as_unread, id: n1.id
      expect(assigns(:notification).read).to be false
    end
    it "should return 404 if notification is from other user" do
      put :mark_as_unread, id: n2.id
      expect(response.code).to eq '404'
    end
    it "should return 404 if notification does not exists" do
      put :mark_as_unread, id: "another-id"
      expect(response.code).to eq '404'
    end
  end

end

