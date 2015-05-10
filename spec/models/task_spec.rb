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

  context "#color" do
    let(:account) { FactoryGirl.create(:account) }
    let(:task) { FactoryGirl.build(:task, account_user_id: account.account_users.first.id ) }

    it "should return account_user color" do
      expect(task.color).to eq account.account_users.first.task_color
    end
    it "should return nil if account_user not set" do
      task.account_user_id = nil
      expect(task.color).to eq nil
    end
  end

  context "#affected_users" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:account) { FactoryGirl.create(:account) }
    let(:calendar) { FactoryGirl.build(:calendar) }
    let(:task) { FactoryGirl.build(:task, calendar: calendar) }
    it "should return user from calendar" do
      expect(task.affected_users).to eq [calendar.user]
    end
    it "should return all users from account" do
      task.calendar = nil
      task.account_id = account.id
      account.add_user(user1)
      account.add_user(user2)
      expect(task.affected_users).to eq account.users
    end
    it "should return empty if task doesnt have calendar and account" do
      task.calendar = nil
      task.account_id = nil
      expect(task.affected_users).to eq []
    end
  end

  context "notifications" do

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

    context "#send_status_changed_notification" do
      let(:task1) { FactoryGirl.create(:task, status: 1) }
      let(:task2) { FactoryGirl.create(:task, status: 2) }
      let(:task3) { FactoryGirl.create(:task, status: 3) }

      it "should send notifications when status changed from 1 to 2" do
        task1.status = 2
        expect(task1).to receive(:send_task_change_notification).and_call_original
        expect_any_instance_of(TasksWorker).to receive(:perform).with(task1.id, 'changed').and_return(nil)
        task1.save
      end

      it "should send notification when status change from 1 to 3" do
        task1.status = 3
        expect(task1).to receive(:send_task_change_notification).and_call_original
        expect_any_instance_of(TasksWorker).to receive(:perform).with(task1.id, 'changed').and_return(nil)
        task1.save
      end

      it "should send notification when status changed from 2 to 1" do
        task2.status = 1
        expect(task2).to receive(:send_task_change_notification).and_call_original
        expect_any_instance_of(TasksWorker).to receive(:perform).with(task2.id, 'changed').and_return(nil)
        task2.save
      end

      it "should send notification when status changed from 2 to 3" do
        task2.status = 3
        expect(task2).to receive(:send_task_change_notification).and_call_original
        expect_any_instance_of(TasksWorker).to receive(:perform).with(task2.id, 'changed').and_return(nil)
        task2.save
      end

      it "should send notification when status changed from 3 to 1" do
        task3.status = 1
        expect(task3).to receive(:send_task_change_notification).and_call_original
        expect_any_instance_of(TasksWorker).to receive(:perform).with(task3.id, 'changed').and_return(nil)
        task3.save
      end

      it "should send notification when status changed from 3 to 2" do
        task3.status = 2
        expect(task3).to receive(:send_task_change_notification).and_call_original
        expect_any_instance_of(TasksWorker).to receive(:perform).with(task3.id, 'changed').and_return(nil)
        task3.save
      end

      it "should not send notification when status is the same" do
        # expect_any_instance_of(TasksWorker).not_to receive(:perform).with('changed')
        task2.status = 2
        expect(task2).not_to receive(:send_task_change_notification)
        task2.save
      end

      it "should not send notification when task is created as status 1" do
        expect_any_instance_of(TasksWorker).not_to receive(:perform).with('changed')
        FactoryGirl.create(:task, status: 1)
      end

      it "should send notification when task is created with status 2" do
        t2 = FactoryGirl.build(:task, status: 2)
        expect(t2).to receive(:send_task_change_notification).once
        t2.save
      end

      it "should send notification when task is created with status 3" do
        t3 = FactoryGirl.build(:task, status: 3)
        expect(t3).to receive(:send_task_change_notification).once
        t3.save
      end

    end

  end

end
