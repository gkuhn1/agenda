require 'rails_helper'

RSpec.describe "UserAccounts", type: :request do
  describe "GET /user_accounts" do
    it "works! (now write some real specs)" do
      get user_accounts_path
      expect(response).to have_http_status(200)
    end
  end
end
