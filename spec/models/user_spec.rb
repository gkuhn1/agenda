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
end
