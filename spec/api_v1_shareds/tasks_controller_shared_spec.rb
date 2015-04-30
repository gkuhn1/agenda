require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:account2) { FactoryGirl.create(:account, user: user) }
  let(:account3) { FactoryGirl.create(:account) }

  let(:calendar) { user.calendar }
  let(:task) { FactoryGirl.create(:task, calendar: calendar) }

  before(:each) {
    @account = account
    @user = user
  }

  it_behaves_like "api v1 controller" do
    let(:extra_params) { {calendar_id: calendar.id} }
  end

  context "#index" do
    it_behaves_like "require current_account" do
      let(:action) {:index}
      let(:extra_params) { {calendar_id: calendar.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:index}
      let(:extra_params) { {calendar_id: calendar.id} }
    end

  end

  context "#show" do
    it_behaves_like "require current_account" do
      let(:action) {:show}
      let(:extra_params) { {id: task.id, calendar_id: calendar.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:show}
      let(:extra_params) { {id: task.id, calendar_id: calendar.id} }
    end
  end

  context "#new" do
    it_behaves_like "require current_account" do
      let(:action) {:new}
      let(:extra_params) { {calendar_id: calendar.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:new}
      let(:extra_params) { {calendar_id: calendar.id} }
    end
  end

  context "#create" do
    let(:task_params) { {calendar_id: calendar.id, task: FactoryGirl.attributes_for(:task)} }

    it_behaves_like "require current_account" do
      let(:action) {:create}
      let(:extra_params) { task_params }
    end

    it_behaves_like "require current_user" do
      let(:action) {:create}
      let(:extra_params) { task_params }
    end
  end

  context "#edit" do
    it_behaves_like "require current_account" do
      let(:action) {:edit}
      let(:extra_params) { {id: task.id, calendar_id: calendar.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:edit}
      let(:extra_params) { {id: task.id, calendar_id: calendar.id} }
    end
  end


  context "#update" do

    let(:task_params) { {id: task.id, calendar_id: calendar.id, task: FactoryGirl.attributes_for(:task)} }

    it_behaves_like "require current_account" do
      let(:action) {:update}
      let(:extra_params) { task_params }
    end

    it_behaves_like "require current_user" do
      let(:action) {:update}
      let(:extra_params) { task_params }
    end
  end

  context "#destroy" do
    it_behaves_like "require current_account" do
      let(:action) {:destroy}
      let(:extra_params) { {id: task.id, calendar_id: calendar.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:destroy}
      let(:extra_params) { {id: task.id, calendar_id: calendar.id} }
    end
  end


end
