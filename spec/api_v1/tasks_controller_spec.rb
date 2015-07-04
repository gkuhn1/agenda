require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:calendar) { user.calendar }
  let(:calendar_tasks) {[
    FactoryGirl.create(:task, calendar: calendar),
    FactoryGirl.create(:task, calendar: calendar),
    FactoryGirl.create(:task, calendar: calendar),
    FactoryGirl.create(:task, calendar: calendar),
  ]}

  let(:account2) { FactoryGirl.create(:account) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:calendar2) { user2.calendar }
  let(:calendar2_tasks) {[
    FactoryGirl.create(:task, calendar: calendar2),
    FactoryGirl.create(:task, calendar: calendar2),
    FactoryGirl.create(:task, calendar: calendar2),
    FactoryGirl.create(:task, calendar: calendar2),
  ]}

  before(:each) {
    api_authenticate(user, account)
  }

  context "#index" do
    before(:each) { [calendar_tasks, calendar2_tasks] }
    it "should return only current_calendar tasks" do
      get :index, {calendar_id: calendar.id}
      expect(assigns(:tasks).size).to eq(4)
      expect(assigns(:tasks)).to match_array(calendar_tasks)
    end
  end

  context "#show" do
    before(:each) { [calendar_tasks, calendar2_tasks] }
    it "should return only informations about current_calendar tasks" do
      get :show, {calendar_id: calendar.id, id: calendar_tasks[1].id}
      expect(response.code).to eq("200")
      expect(assigns(:task)).to eq(calendar_tasks[1])
    end
    # it "should return 404 if task is from other account" do
    #   pending "problema da issue #4002 do mongoid"
    #   get :show, {id: calendar2_tasks[1].id}
    #   expect(response.code).to eq("404")
    # end


    context "filtering" do
      render_views

      let!(:t1) { FactoryGirl.create(:task, calendar: calendar,
        start_at: "2015-04-27T14:00:00.501-03:00", end_at: "2015-04-27T15:00:00.501-03:00", created_by_id: user.id) }
      let!(:t2) { FactoryGirl.create(:task, calendar: calendar,
        start_at: "2015-04-26T14:00:00.501-03:00", end_at: "2015-04-26T15:00:00.501-03:00", created_by_id: user.id) }
      let!(:t3) { FactoryGirl.create(:task, calendar: calendar,
        start_at: "2015-04-17T14:00:00.501-03:00", end_at: "2015-04-17T15:00:00.501-03:00", created_by_id: user.id) }
      let!(:t4) { FactoryGirl.create(:task, calendar: calendar,
        start_at: "2015-05-02T14:00:00.501-03:00", end_at: "2015-05-05T15:00:00.501-03:00", created_by_id: user.id) }

      it "should filter tasks if start_at and end_at is present" do
        get :index, {tasks: true, start_at: "2015-04-27T10:00:00.501-03:00", end_at: "2015-04-27T18:00:00.501-03:00"}
        body = JSON.parse(response.body)
        expect(body.count).to eq(1)
        expect(body).to eq(
          [{"id"=>t1.id,
          "calendar_id"=>calendar.id,
          "account_id"=>nil,
          "title"=>"My Task",
          "description"=>"My Task description",
          "where"=>"My task location",
          "status"=>1,
          "status_description"=>"Aguardando confirmação",
          "start_at"=>"2015-04-27T14:00:00.501-03:00",
          "created_by_id"=>user.id,
          "end_at"=>"2015-04-27T15:00:00.501-03:00",
          "task_color"=>"#909090"
          }]
        )
      end

    end
  end

  context "#create" do
    let(:task_params) {{
      "calendar_id": calendar.id,
      "task": {
        "id": "5532e21d676b7518ca010000",
        "title": "Corte de cabelo Masculino",
        "description": nil,
        "where": "Salão",
        "start_at": "2015-04-18T10:00:00",
        "end_at": "2015-04-18T10:15:00"
      }
    }}
    it "should always create task with status 1" do
      post :create, task_params
      expect(assigns(:task).status).to eq(1)
    end
    it "should ignore status passed to param" do
      task_params[:task].merge!("status"=>"99")
      post :create, task_params
      expect(assigns(:task).valid?).to be(false)
      expect(assigns(:task).status).to eq(99)
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
