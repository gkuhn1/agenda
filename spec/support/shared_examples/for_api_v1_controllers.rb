RSpec.shared_examples "api v1 controller" do

  let(:action) {:index}
  let(:account) { @account || FactoryGirl.create(:account) }
  let(:user) { @user || account.users.first }

  let(:extra_params) {{}}

  context "authentication" do
    it "should require autentication" do
      api_authenticate(nil, nil)
      get action, extra_params
      expect(response.code).to eq("401")
    end
    it "should autenticate and select account" do
      api_authenticate(user, account)
      get action, extra_params
      expect(response.code).to eq("200")
      expect(assigns(:current_account)).to eq(account)
    end
  end

  context "format" do
    it "should accept json" do
      api_authenticate(user, account)
      get action, extra_params
      expect(response.code).to eq("200")
    end
    it "should return 406 not acceptable for html" do
      api_authenticate(user, account)
      set_content_type("text/html")
      get action, extra_params
      expect(response.code).to eq("406")
    end
    it "should return 406 not acceptable for xml" do
      api_authenticate(user, account)
      set_content_type("text/xml")
      get action, extra_params
      expect(response.code).to eq("406")
    end
  end

end