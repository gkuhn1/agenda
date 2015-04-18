require 'rails_helper'

describe RequireCalendar, type: :controller do

  let(:account) {FactoryGirl.create(:account)}
  let(:user) { account.users.first }

  let(:calendar) { FactoryGirl.create(:calendar, user: user) }

  controller(ApplicationController) do
    include RequireCalendar
    before_filter :set_calendar, :require_calendar

    def index
      render :json => {:success => 'OK'}, :status => 200
    end

  end

  before(:each) do
    api_authenticate(user, account)
  end

  it "should return 401 error if calendar is not in params" do
    get :index
    expect(response.code).to eq("401")
    expect(response.body).to eq({:error => 'Agenda não informada (calendar_id).'}.to_json)
  end

  it "should accept if calendar_id is in params" do
    get :index, calendar_id: calendar.id
    expect(response.code).to eq("200")
  end
end