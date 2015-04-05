require 'rails_helper'

describe Account, type: :model do
  context "validations" do
    it "should require a name" do
      account = Account.new
      expect(account.valid?).to be(false)
      expect(account.errors[:name]).to eq(["não pode ficar em branco"])
    end
    it "should call fill_out_db before validation" do
      account = Account.new(:name => "test")
      expect(account).to receive(:fill_out_db).once.and_call_original
      expect(account.valid?).to be(false)
      expect(account.database).not_to eq(nil)
    end
    it "should hava at least one user" do
      account = Account.new
      expect(account.valid?).to be(false)
      expect(account.errors[:user_ids]).to eq(["não pode ficar em branco"])
    end
  end

  context ".fill_out_db" do
    it "should set database based on name" do
      account = Account.new(:name => "MyAccount")
      account.valid?
      expect(account.database).to eq("myaccount")
    end
    it "should not set duplicated database" do
      a = FactoryGirl.create(:account, :name => "MyAccount", :database => "myaccount")
      account = Account.new(:name => "MyAccount")
      account.valid?
      expect(account.database).to eq("myaccount_1")
    end
    it "should not be called if database is filled" do
      account = FactoryGirl.build(:account, :name => "MyAccount", :database => "myaccount123")
      expect(account).not_to receive(:fill_out_db)
      expect(account.valid?).to be(true)
    end
  end

  context ".add_user" do
    it "should add an user and save both account and user" do
      account = FactoryGirl.create(:account)
      user = FactoryGirl.create(:user)
      expect(account).to receive(:save).and_call_original
      expect(user).to receive(:save).twice.and_call_original
      account.add_user(user)
      expect(account.user_ids).to include(user._id)
    end
  end
end

