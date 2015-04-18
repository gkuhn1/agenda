require 'rails_helper'

RSpec.describe Calendar, type: :model do

  context "#validations" do
    it "should require user" do
      calendar = FactoryGirl.build(:calendar, user: nil)
      expect(calendar.valid?).to be(false)
      expect(calendar.errors[:user]).to eq(["não pode ficar em branco"])
    end
  end

end
