require 'rails_helper'

RSpec.describe Notification, type: :model do

  let(:user) { FactoryGirl.build(:user) }

  context "#validations" do
    it "should require an user" do
      notification = FactoryGirl.build(:notification)
      expect(notification.valid?).to be(false)
      expect(notification.errors[:user]).to eq(["não pode ficar em branco"])
    end

    it "should require a text" do
      notification = FactoryGirl.build(:notification, text: nil)
      expect(notification.valid?).to be(false)
      expect(notification.errors[:text]).to eq(["não pode ficar em branco"])
    end

    it "should require a title" do
      notification = FactoryGirl.build(:notification, title: nil)
      expect(notification.valid?).to be(false)
      expect(notification.errors[:title]).to eq(["não pode ficar em branco"])
    end

    it "should require unknown type" do
      notification = FactoryGirl.build(:notification, type: 99)
      expect(notification.valid?).to be(false)
      expect(notification.errors[:type]).to eq(["desconhecido"])
    end

    it "should accept any type in TYPES" do
      Notification::TYPES.each do |key, label|
        notification = FactoryGirl.build(:notification, type: key, user: user)
        expect(notification.valid?).to be(true)
      end
    end
  end

  context "scopes" do
    describe "sys" do
      it "should list only system notifications" do
        FactoryGirl.create(:notification, type: 1, user: user)
        FactoryGirl.create(:notification, type: 1, user: user)
        FactoryGirl.create(:notification, type: 2, user: user)
        FactoryGirl.create(:notification, type: 2, user: user)

        expect(Notification.sys.count).to eq(2)
      end
    end

    describe "to_user" do
      let(:user2) {FactoryGirl.build(:user)}
      it "should return only notifications to passed user" do
        FactoryGirl.create(:notification, type: 1, user: user)
        FactoryGirl.create(:notification, type: 1, user: user2)
        FactoryGirl.create(:notification, type: 2, user: user2)
        FactoryGirl.create(:notification, type: 2, user: user)

        expect(Notification.to_user(user2).count).to eq(2)
      end
    end

    describe "reads" do
      it "should return only reads notifications" do
        FactoryGirl.create(:notification_read, type: 1, user: user, read_at: Time.now)
        n = FactoryGirl.create(:notification_read, type: 1, user: user, read_at: nil)
        FactoryGirl.create(:notification_read, type: 2, user: user, read_at: Time.now)
        FactoryGirl.create(:notification, type: 2, user: user)

        n.mark_as_read
        n.mark_as_unread

        expect(Notification.reads.count).to eq(2)
      end
    end

    describe "unreads" do
      it "should return only unreads notifications" do
        FactoryGirl.create(:notification_read, type: 1, user: user)
        FactoryGirl.create(:notification, type: 1, user: user)
        FactoryGirl.create(:notification_read, type: 2, user: user, read_at: nil)
        n = FactoryGirl.create(:notification, type: 2, user: user)
        n.mark_as_read
        n.mark_as_unread

        expect(Notification.unreads.count).to eq(2)
      end
    end
  end


  context "#mark_as_read" do
    let(:notification) {FactoryGirl.create(:notification, user:user)}
    it "should mark an notification as read" do
      notification.mark_as_read
      expect(notification.read).to be(true)
      expect(notification.read_at).not_to be_nil
    end
  end

  context "#mark_as_unread" do
    let(:notification) {FactoryGirl.create(:notification_read, user:user)}
    it "should clear read_at notification attribute" do
      notification.mark_as_unread
      expect(notification.read).to be(false)
      expect(notification.read_at).to be_nil
    end
  end

end
