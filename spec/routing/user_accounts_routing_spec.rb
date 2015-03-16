require "rails_helper"

RSpec.describe UserAccountsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/user_accounts").to route_to("user_accounts#index")
    end

    it "routes to #new" do
      expect(:get => "/user_accounts/new").to route_to("user_accounts#new")
    end

    it "routes to #show" do
      expect(:get => "/user_accounts/1").to route_to("user_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/user_accounts/1/edit").to route_to("user_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/user_accounts").to route_to("user_accounts#create")
    end

    it "routes to #update" do
      expect(:put => "/user_accounts/1").to route_to("user_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/user_accounts/1").to route_to("user_accounts#destroy", :id => "1")
    end

  end
end
