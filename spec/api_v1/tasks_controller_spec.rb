require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:account2) { FactoryGirl.create(:account) }
  let(:user2) { FactoryGirl.create(:user) }

  let(:calendar) { FactoryGirl.create(:calendar, user: user) }
  let(:calendar2) { FactoryGirl.create(:calendar, user: user2) }
  let(:calendar_tasks) {[
    FactoryGirl.create(:task, calendar: calendar),
    FactoryGirl.create(:task, calendar: calendar),
    FactoryGirl.create(:task, calendar: calendar),
    FactoryGirl.create(:task, calendar: calendar),
  ]}
  let(:calendar2_tasks) {[
    FactoryGirl.create(:task, calendar: calendar2),
    FactoryGirl.create(:task, calendar: calendar2),
    FactoryGirl.create(:task, calendar: calendar2),
    FactoryGirl.create(:task, calendar: calendar2),
  ]}

  before(:each) {
    api_authenticate(user, account)
    [calendar_tasks, calendar2_tasks]
  }

  context "#index" do
    it "should return only current_calendar tasks" do
      get :index, {calendar_id: calendar.id}
      expect(assigns(:tasks).size).to eq(4)
      expect(assigns(:tasks)).to match_array(calendar_tasks)
    end
  end

  context "#show" do
    it "should return only informations about current_calendar tasks" do
      get :show, {calendar_id: calendar.id, id: calendar_tasks[1].id}
      expect(response.code).to eq("200")
      expect(assigns(:task)).to eq(calendar_tasks[1])
    end
    it "should return 404 if calendar is from other account" do
      get :show, {calendar_id: calendar.id, id: calendar2_tasks[1].id}
      expect(response.code).to eq("404")
    end
  end


end
