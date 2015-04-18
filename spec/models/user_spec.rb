require 'rails_helper'

RSpec.describe User, type: :model do
  context "Validations" do
    it "should require name" do
      user = User.new
      expect(user.valid?).to be(false)
      expect(user.errors[:name]).to eq(["não pode ficar em branco"])
    end
    it "should require token" do
      expect_any_instance_of(User).to receive(:generate_token!).and_return(nil)
      user = User.new(name: "Guilherme")
      expect(user.valid?).to be(false)
      expect(user.errors[:token]).to eq(["não pode ficar em branco"])
    end
    it "should require email" do
      user = User.new
      expect(user.valid?).to be(false)
      expect(user.errors[:email]).to eq(["não pode ficar em branco"])
    end
    it "should validate email" do
      user = User.new(:email => "aaaaaaaa")
      expect(user.valid?).to be(false)
      expect(user.errors[:email]).to eq(["não é válido"])
    end
    it "should block duplicated e-mails" do
      FactoryGirl.create(:user, email: "g.kuhn0@gmail.com")
      user = User.new(:email => "g.kuhn0@gmail.com")
      expect(user.valid?).to be(false)
      expect(user.errors[:email]).to eq(["já está em uso"])
    end
  end

  context "before_validations" do
    it "should fill token before validation" do
      user = FactoryGirl.build(:user)
      expect(user.token).to eq(nil)
      expect(user.valid?).to be(true)
      expect(user.token).not_to eq(nil)
    end
  end

  context "admin?" do
    it "should return true if user.admin is true" do
      user = FactoryGirl.build(:user, :admin => true)
      expect(user.admin?).to be(true)
    end
    it "should return false if user.admin is false" do
      user = FactoryGirl.build(:user, :admin => false)
      expect(user.admin?).to be(false)
    end
  end

  context "generate_password!" do
    let(:user) {FactoryGirl.build(:user, :admin => true)}
    it "should generate a new password if password is empty and generate_password flag is true" do
      user.generate_password = true
      user.password = nil
      user.generate_password!
      expect(user.encrypted_password).not_to eq(nil)
    end
    it "should not generate if password already exists" do
      user.generate_password = true
      user.password = "test"
      encrypted = user.encrypted_password
      user.generate_password!
      expect(user.encrypted_password).to eq(encrypted)
    end
    it "should not generate if generate_password flag is false" do
      encrypted = user.encrypted_password
      user.generate_password!
      expect(user.encrypted_password).to eq(encrypted)
    end
  end

  context "generate_token!" do
    let(:user) {FactoryGirl.build(:user, :admin => true)}
    it "should generate a new token if token is blank" do
      user.token = ""
      user.generate_token!
      expect(user.token).not_to eq("")
    end
    it "should not generate if token is blank" do
      user.token = "123"
      user.generate_token!
      expect(user.token).to eq("123")
    end
    it "should generate if token is nil" do
      user.token = nil
      user.generate_token!
      expect(user.token).not_to eq(nil)
    end
  end

  context "create_calendar!" do
    let(:user) {FactoryGirl.build(:user, :admin => true)}
    it "should create new calendar after create" do
      expect { user.save! }.to change(Calendar, :count).by(1)
    end
    it "should not create a new calendar if user already has one" do
      user.save!
      expect { user.save! }.to change(Calendar, :count).by(0)
    end
  end

  context "destroy_calendar!" do
    let(:user) {FactoryGirl.create(:user, :admin => true)}
    it "should create new calendar after create" do
      user
      expect { user.destroy }.to change(Calendar, :count).by(-1)
    end
    it "should not create a new calendar if user already has one" do
      user.calendar.destroy
      expect { user.destroy }.to change(Calendar, :count).by(0)
    end
  end
end
