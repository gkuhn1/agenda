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

    context "filtering" do
      render_views

      let!(:t1) { FactoryGirl.create(:task, calendar: calendar,
        start_at: "2015-04-27T14:00:00.501-03:00", end_at: "2015-04-27T15:00:00.501-03:00") }
      let!(:t2) { FactoryGirl.create(:task, calendar: calendar,
        start_at: "2015-04-26T14:00:00.501-03:00", end_at: "2015-04-26T15:00:00.501-03:00") }
      let!(:t3) { FactoryGirl.create(:task, calendar: calendar,
        start_at: "2015-04-17T14:00:00.501-03:00", end_at: "2015-04-17T15:00:00.501-03:00") }
      let!(:t4) { FactoryGirl.create(:task, calendar: calendar,
        start_at: "2015-05-02T14:00:00.501-03:00", end_at: "2015-05-05T15:00:00.501-03:00") }

      it "should filter tasks if start_at and end_at is present" do
        get :index, {tasks: true, start_at: "2015-04-27T10:00:00.501-03:00", end_at: "2015-04-27T19:00:00.501-03:00"}
        body = JSON.parse(response.body)
        rendered_calendar = body.select{ |c| c["id"] == calendar.id}.first
        expect(rendered_calendar["tasks"].count).to eq(1)
        expect(rendered_calendar["tasks"]).to eq(
          [{"id"=>t1.id,
          "calendar_id"=>calendar.id,
          "title"=>"My Task",
          "description"=>"My Task description",
          "where"=>"My task location",
          "status"=>1,
          "status_description"=>"Criado",
          "start_at"=>"2015-04-27T14:00:00.501-03:00",
          "end_at"=>"2015-04-27T15:00:00.501-03:00"}]
        )
      end

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



  context "task_filter_params" do
    let(:params) {ActionController::Parameters.new({
      calendar: "12331",
      start_at: "start_at",
      end_at: "end_at",
      other: 0
    })}
    it "should return only start_at and end_at params" do
      allow(controller).to receive(:params).and_return(params)
      expect(controller.send(:task_filter_params)).to eq({"start_at"=> "start_at", "end_at"=> "end_at"})
    end
  end


end
