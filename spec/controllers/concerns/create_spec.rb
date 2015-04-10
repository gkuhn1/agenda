require 'rails_helper'

describe Create, type: :controller do


  let(:account) {FactoryGirl.create(:account)}
  let(:user) { account.users.first }
  let(:auth_params) { {} }

  before :each do
    auth_params
  end

  controller(Api::V1::UsersController) do
  end

  before { routes.draw {
    namespace :api do
      namespace :v1 do
        resources :users, only: [:create]
      end
    end
  }}

  before(:each) do
    api_authenticate(user, account)
  end

  it "should create user and return code 201 created" do
    expect { post :create, auth_params.merge(user: FactoryGirl.attributes_for(:user)) }.to change(User, :count).by(1)
    expect(response.code).to eq('201')
  end

  it "should return 422 if validation error with errors" do
    auth_params.merge!(user: FactoryGirl.attributes_for(:user))
    auth_params[:user].merge!(:email => "aaaaa")
    expect { post :create, auth_params }.not_to change(User, :count)
    expect(response.code).to eq('422')
    expect(response.body).to eq({:errors => {:email => ['não é válido']}}.to_json)
  end



end
