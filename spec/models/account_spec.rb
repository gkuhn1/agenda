require 'rails_helper'

describe Account, type: :model do
  context "validations" do
    it "should require a name" do
      account = Account.new
      expect(account.valid?).to be(false)
      expect(account.errors[:name]).to eq(["não pode ficar em branco"])
    end
    # it "should call fill_out_db before validation" do
    #   account = Account.new(:name => "test")
    #   expect(account).to receive(:fill_out_db).once.and_call_original
    #   expect(account.valid?).to be(false)
    #   expect(account.database).not_to eq(nil)
    # end
    # it "should hava at least one user" do
    #   account = Account.new
    #   expect(account.valid?).to be(false)
    #   expect(account.errors[:user_ids]).to eq(["não pode ficar em branco"])
    # end
  end

  context ".build_user_from_attributes" do
    it "should build an user if user_attributes is set" do
      account = Account.new(:name => "MyAccount", user_attributes: FactoryGirl.attributes_for(:user))
      account.build_user_from_attributes
      expect(account.instance_variable_get("@user_from_attributes")).not_to eq(nil)
      expect(account.errors).to be_empty
    end

    it "should do noting if user_attribtes is not set" do
      account = Account.new(:name => "MyAccount")
      account.build_user_from_attributes
      expect(account.instance_variable_get("@user_from_attributes")).to be(nil)
      expect(account.errors).to be_empty
    end

    it "should return errors if user_attributes has errors" do
      account = Account.new(:name => "MyAccount", user_attributes: {:name=>"My User 1", :email=>"invalid", :password=>"mypassword"})
      account.build_user_from_attributes
      expect(account.instance_variable_get("@user_from_attributes")).not_to eq(nil)
      expect(account.errors.to_h).to eq({:user_email=>"não é válido"})
    end
  end

  context ".create_user_from_attributes" do
    it "should save user if user exists" do
      account = FactoryGirl.build(:account)
      user = FactoryGirl.build(:user)
      account.instance_variable_set("@user_from_attributes", user)
      account.save
      expect(account.users).to include(user)
    end
    it "should do nothing if user doesn't exists" do
      account = FactoryGirl.build(:account)
      account.create_user_from_attributes
      expect(account.users.count).to eq(0)
    end
  end

  # context ".fill_out_db" do
  #   it "should set database based on name" do
  #     account = Account.new(:name => "MyAccount")
  #     account.valid?
  #     expect(account.database).to eq("myaccount")
  #   end
  #   it "should not set duplicated database" do
  #     a = FactoryGirl.create(:account, :name => "MyAccount", :database => "myaccount")
  #     account = Account.new(:name => "MyAccount")
  #     account.valid?
  #     expect(account.database).to eq("myaccount_1")
  #   end
  #   it "should not be called if database is filled" do
  #     account = FactoryGirl.build(:account, :name => "MyAccount", :database => "myaccount123")
  #     expect(account).not_to receive(:fill_out_db)
  #     expect(account.valid?).to be(true)
  #   end
  # end

  context ".add_user" do
    it "should add an user to account" do
      account = FactoryGirl.create(:account)
      user = FactoryGirl.create(:user)
      account.add_user(user)
      expect(account.users).to include(user)
    end
    it "should ignore if user already are in account" do
      account = FactoryGirl.create(:account)
      user = FactoryGirl.create(:user)
      expect(account.add_user(user)).to be_instance_of(AccountUser)
      expect(account.add_user(user)).to be nil
      expect(account.users).to include(user)
    end
  end
end

