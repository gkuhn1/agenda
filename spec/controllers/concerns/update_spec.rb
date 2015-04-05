require 'rails_helper'

describe Update, type: :controller do


  let(:account) {FactoryGirl.create(:account)}
  let(:user) { account.users.first }
  let(:auth_params) { {format: 'json', user_email: user.email, user_token: user.token, user_account: account.id} }

  before :each do
    auth_params
  end

  controller(Api::V1::UsersController) do
  end

  before { routes.draw {
    namespace :api do
      namespace :v1 do
        resources :users, only: [:update]
      end
    end
  }}

  it "should create user and return code 201 created" do
    post :update, auth_params.merge(id: user.id, user: FactoryGirl.attributes_for(:user, :name => "New Name"))
    expect(response.code).to eq('200')
    expect(assigns(:user).name).to eq("New Name")
  end

  it "should return 422 if validation error with errors" do
    auth_params.merge!(user: FactoryGirl.attributes_for(:user))
    auth_params[:user].merge!(:email => "aaaaa")

    post :update, auth_params.merge(id: user.id)

    expect(response.code).to eq('422')
    expect(response.body).to eq({:errors => {:email => ['não é válido']}}.to_json)
  end

end
