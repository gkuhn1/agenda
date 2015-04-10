RSpec.shared_examples "api v1 controller" do

  let(:action) {:index}
  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }


  context "authentication" do
    it "should require autentication" do
      api_authenticate(nil, nil)
      get action
      expect(response.code).to eq("401")
    end
    it "should autenticate and select account" do
      api_authenticate(user, account)
      get action
      expect(response.code).to eq("200")
      expect(assigns(:current_account)).to eq(account)
    end
  end

  context "format" do
    it "should accept json" do
      api_authenticate(user, account)
      get action
      expect(response.code).to eq("200")
    end
    it "should return 406 not acceptable for html" do
      api_authenticate(user, account)
      set_content_type("text/html")
      get action
      expect(response.code).to eq("406")
    end
    it "should return 406 not acceptable for xml" do
      api_authenticate(user, account)
      set_content_type("text/xml")
      get action
      expect(response.code).to eq("406")
    end
  end

end