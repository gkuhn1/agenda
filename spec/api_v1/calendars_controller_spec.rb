require 'rails_helper'

RSpec.describe Api::V1::CalendarsController, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:user2) do
    u = FactoryGirl.create(:user)
    account.add_user(u)
    u
  end
  let(:account2) { FactoryGirl.create(:account, user: user) }
  let(:account3) { FactoryGirl.create(:account) }
  let(:user3) { FactoryGirl.create(:user) }
  let(:user4) { account3.users.first }

  let(:calendar) { user.calendar }
  let(:calendar1) { user2.calendar }
  let(:calendar2) { user3.calendar }
  let(:calendar3) { user4.calendar }

  before(:each) {
    api_authenticate(user, account)
    [calendar, calendar1, calendar2, calendar3]
  }

  context "#index" do
    it "should return only current_account calendars" do
      get :index
      expect(assigns(:calendars).size).to eq(2)
      expect(assigns(:calendars)).to match_array([calendar, calendar1])
    end
  end

  context "#show" do
    it "should return only informations about current_account calendars" do
      get :show, {id: calendar.id}
      expect(response.code).to eq("200")
      expect(assigns(:calendar)).to eq(calendar)
    end
    it "should return 404 if calendar is from other account" do
      get :show, {id: calendar3.id}
      expect(response.code).to eq("404")
    end
  end

end
