require 'rails_helper'

RSpec.describe Specialty, type: :model do
  let(:account) { FactoryGirl.create(:account) }

  context "validations" do
    it "should require description" do
      specialty = FactoryGirl.build(:specialty, description: "")
      expect(specialty.valid?).to be false
      expect(specialty.errors[:description]).to eq ["não pode ficar em branco"]
    end

    it "should require an account" do
      specialty = FactoryGirl.build(:specialty, description: "")
      expect(specialty.valid?).to be false
      expect(specialty.errors[:account]).to eq ["não pode ficar em branco"]
    end
  end

  context "deleted_at" do
    let(:specialty) { FactoryGirl.create(:specialty, account: account) }
    it "should not exclude an specialty if it is deleted" do
      specialty
      expect { specialty.destroy }.not_to change(Specialty, :count)
    end

    context "not_deleted" do
      before(:each) do
        FactoryGirl.create(:specialty, account: account).destroy
        FactoryGirl.create(:specialty, account: account).destroy
        FactoryGirl.create(:specialty, account: account)
      end
      it "should not return an specialty if it is delete" do
        expect(Specialty.not_deleted.count).to eq 1
      end
      it "should return all specialty if no scope is used" do
        expect(Specialty.count).to eq 3
      end
    end
  end
end
