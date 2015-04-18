require 'rails_helper'

RSpec.describe Api::V1::CalendarsController, type: :controller do

  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:account2) { FactoryGirl.create(:account, user: user) }
  let(:account3) { FactoryGirl.create(:account) }

  let(:calendar) { user.calendar }

  before(:each) {
    @account = account
    @user = user
  }

  it_behaves_like "api v1 controller"

  context "#index" do
    it_behaves_like "require current_account" do
      let(:action) {:index}
      let(:extra_params) { {id: calendar.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:index}
      let(:extra_params) { {id: calendar.id} }
    end

  end

  context "#show" do
    it_behaves_like "require current_account" do
      let(:action) {:show}
      let(:extra_params) { {id: calendar.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:show}
      let(:extra_params) { {id: calendar.id} }
    end
  end

  # Não pode criar novos calendarios
  # context "#new" do
  #   it_behaves_like "require current_account" do
  #     let(:action) {:new}
  #   end

  #   it_behaves_like "require current_user" do
  #     let(:action) {:new}
  #   end
  # end

  # context "#create" do
  #   let(:calendar_params) { {calendar: FactoryGirl.attributes_for(:calendar).merge(user_id: user.id)} }

  #   it_behaves_like "require current_account" do
  #     let(:action) {:create}
  #     let(:extra_params) { calendar_params }
  #   end

  #   it_behaves_like "require current_user" do
  #     let(:action) {:create}
  #     let(:extra_params) { calendar_params }
  #   end
  # end

  context "#edit" do
    it_behaves_like "require current_account" do
      let(:action) {:edit}
      let(:extra_params) { {id: calendar.id} }
    end

    it_behaves_like "require current_user" do
      let(:action) {:edit}
      let(:extra_params) { {id: calendar.id} }
    end
  end


  context "#update" do

    let(:calendar_params) { {id: calendar.id, calendar: FactoryGirl.attributes_for(:calendar).merge(user_id: user.id)} }

    it_behaves_like "require current_account" do
      let(:action) {:update}
      let(:extra_params) { calendar_params }
    end

    it_behaves_like "require current_user" do
      let(:action) {:update}
      let(:extra_params) { calendar_params }
    end
  end

  # context "#destroy" do
  #   it_behaves_like "require current_account" do
  #     let(:action) {:destroy}
  #     let(:extra_params) { {id: calendar.id} }
  #   end

  #   it_behaves_like "require current_user" do
  #     let(:action) {:destroy}
  #     let(:extra_params) { {id: calendar.id} }
  #   end
  # end


end
