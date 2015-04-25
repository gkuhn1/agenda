require 'rails_helper'

RSpec.describe AccountUser, type: :model do

  context "validation" do
    it "should invalidate if permission is not knowed" do
      account_user = FactoryGirl.build(:account_user, permission: "any")
      expect(account_user.valid?).to be false
      expect(account_user.errors[:permission]).to eq(["permissão desconhecida."])
    end
  end


  context "permission!" do
    it "should return description of permission" do
      AccountUser::PERMISSIONS.each do |key, val|
        account_user = FactoryGirl.build(:account_user, permission: key)
        expect(account_user.permission!).to eq(val)
      end
    end
  end
end
