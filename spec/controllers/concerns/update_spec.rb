require 'rails_helper'

describe Update, type: :controller do


  let(:account) {FactoryGirl.create(:account)}
  let(:user) { account.users.first }

  controller(Api::V1::UsersController) do
  end

  before { routes.draw {
    namespace :api do
      namespace :v1 do
        resources :users, only: [:update]
      end
    end
  }}

  before(:each) do
    api_authenticate(user, account)
  end

  it "should create user and return code 201 created" do
    post :update, {id: user.id, user: FactoryGirl.attributes_for(:user, :name => "New Name")}
    expect(response.code).to eq('200')
    expect(assigns(:user).name).to eq("New Name")
  end

  it "should return 422 if validation error with errors" do
    user_params = FactoryGirl.attributes_for(:user, :email => "aaaaa")

    post :update, {id: user.id, user: user_params}

    expect(response.code).to eq('422')
    expect(response.body).to eq({:errors => {:email => ['não é válido']}}.to_json)
  end

end
