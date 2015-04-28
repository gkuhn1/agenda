require 'rails_helper'

RSpec.describe Calendar, type: :model do

  context "#validations" do
    it "should require user" do
      calendar = FactoryGirl.build(:calendar, user: nil)
      expect(calendar.valid?).to be(false)
      expect(calendar.errors[:user]).to eq(["não pode ficar em branco"])
    end
  end


  context "#filter_tasks" do

    let(:calendar) { FactoryGirl.create(:calendar) }
    let!(:t1) { FactoryGirl.create(:task, calendar: calendar,
      start_at: "2015-04-27T14:00:00.501-03:00", end_at: "2015-04-27T15:00:00.501-03:00") }
    let!(:t2) { FactoryGirl.create(:task, calendar: calendar,
      start_at: "2015-04-26T14:00:00.501-03:00", end_at: "2015-04-26T15:00:00.501-03:00") }
    let!(:t3) { FactoryGirl.create(:task, calendar: calendar,
      start_at: "2015-04-17T14:00:00.501-03:00", end_at: "2015-04-17T15:00:00.501-03:00") }
    let!(:t4) { FactoryGirl.create(:task, calendar: calendar,
      start_at: "2015-05-02T14:00:00.501-03:00", end_at: "2015-05-05T15:00:00.501-03:00") }

    it "should filter with start_at and end_at in the same day" do
      expect(calendar.filter_tasks({start_at: "2015-04-27", end_at: "2015-04-27"}).count).to eq(1)
    end

    it "should filter with start_at and end_at in diferent days" do
      expect(calendar.filter_tasks({start_at: "2015-04-23", end_at: "2015-04-27"}).count).to eq(2)
    end

    it "should fiter based on datetime" do
      expect(calendar.filter_tasks({start_at: "2015-04-27T10:00:00.501-03:00", end_at: "2015-04-27T18:00:00.501-03:00"}).count).to eq(1)
    end

    it "should not filter with start_at and end_at nil" do
      expect(calendar.filter_tasks({start_at: nil, end_at: nil}).count).to eq(4)
    end

    it "should return all tasks with invalid dates" do
      expect(calendar.filter_tasks({start_at: "2015-33-55", end_at: "2015-33-54"}).count).to eq(4)
    end
  end

end
