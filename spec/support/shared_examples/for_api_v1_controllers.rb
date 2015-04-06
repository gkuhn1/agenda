RSpec.shared_examples "api v1 controller" do

  let(:action) {:index}
  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }


  context "authentication" do
    it "should require autentication" do
      get action, :format => 'json'
      expect(response.code).to eq("404")
    end
    it "should autenticate and select account" do
      get action, {:format => 'json'}, api_authenticate(user, account)
      expect(response.code).to eq("200")
      expect(assigns(:current_account)).to eq(account)
    end
  end

  context "format" do
    it "should accept json" do
      get action, {:format => 'json'}, api_authenticate(user, account)
      expect(response.code).to eq("200")
    end
    it "should return 406 not acceptable for html" do
      get action, {:format => 'html'}, api_authenticate(user, account)
      expect(response.code).to eq("406")
    end
    it "should return 406 not acceptable for xml" do
      get action, {:format => 'xml'}, api_authenticate(user, account)
      expect(response.code).to eq("406")
    end
  end

end