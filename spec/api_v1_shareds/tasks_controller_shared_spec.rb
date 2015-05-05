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

  it_behaves_like "api v1 controller"

  context "#index" do
    it_behaves_like "require current_account" do
      let(:action) {:index}
    end

    it_behaves_like "require current_user" do
      let(:action) {:index}
    end

  end

  context "#show" do
    it_behaves_like "require current_account" do
      let(:action) {:show}
      let(:extra_params) { {id: task.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:show}
      let(:extra_params) { {id: task.id} }
    end
  end

  context "#new" do
    it_behaves_like "require current_account" do
      let(:action) {:new}
    end

    it_behaves_like "require current_user" do
      let(:action) {:new}
    end
  end

  context "#create" do
    let(:task_params) { {task: FactoryGirl.attributes_for(:task).merge(calendar_id: calendar.id) } }

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
      let(:extra_params) { {id: task.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:edit}
      let(:extra_params) { {id: task.id} }
    end
  end


  context "#update" do

    let(:task_params) { {id: task.id, task: FactoryGirl.attributes_for(:task)} }

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
      let(:extra_params) { {id: task.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:destroy}
      let(:extra_params) { {id: task.id} }
    end
  end


end
