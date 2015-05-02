require 'rails_helper'

RSpec.describe Task, type: :model do

  context "validations" do
    it "should require an title" do
      task = FactoryGirl.build(:task, title: nil)
      expect(task.valid?).to be(false)
      expect(task.errors[:title]).to eq(["não pode ficar em branco"])
    end
    it "should set status to 1 if blank" do
      task = FactoryGirl.build(:task, status: nil)
      expect(task.valid?).to be(true)
      expect(task.status).to eq(1)
    end
    it "should requite an start_at" do
      task = FactoryGirl.build(:task, start_at: nil)
      expect(task.valid?).to be(false)
      expect(task.errors[:start_at]).to eq(["não pode ficar em branco"])
    end
    it "should require an end_at" do
      task = FactoryGirl.build(:task, end_at: nil)
      expect(task.valid?).to be(false)
      expect(task.errors[:end_at]).to eq(["não pode ficar em branco"])
    end

    it "should not accept status not defined in Task::STATUS" do
      task = FactoryGirl.build(:task, status: -1)
      expect(task.valid?).to be(false)
      expect(task.errors[:status]).to eq(["situação desconhecida."])
    end

    it "should accept all status defined in Task::STATUS" do
      Task::STATUS.each do |key, label|
        task = FactoryGirl.build(:task, status: key)
        expect(task.valid?).to be(true)
      end
    end
  end

  context "#status!" do
    let(:task) { FactoryGirl.build(:task, status: 1) }
    it "should return status description" do
      expect(task.status!).to eq(Task::STATUS[1])
    end
  end

  context "#create_notification" do
    let(:task) { FactoryGirl.build(:task, status: 1) }
    it "should not create a notification if user is the same" do
      task.created_by = FactoryGirl.create(:user)
      task.calendar = task.created_by.calendar
      expect { task.save }.not_to change(Notification, :count)
    end
    it "should send notification to calendar task user's if task was created by another user" do
      task.created_by = FactoryGirl.create(:user)
      task.calendar = FactoryGirl.create(:user).calendar
      expect { task.save }.to change(Notification, :count).by(1)
    end
  end

end
