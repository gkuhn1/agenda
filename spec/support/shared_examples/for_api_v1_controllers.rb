RSpec.shared_examples "api v1 controller" do

  let(:action) {:index}
  let(:account) { FactoryGirl.create(:account) }
  let(:user) { account.users.first }
  let(:auth_params) { {user_email: user.email, user_token: user.token, user_account: account.id.to_s} }


  context "authentication" do
    it "should require autentication" do
      get action, :format => 'json'
      expect(response.code).to eq("401")
    end
    it "should autenticate and select account" do
      get action, auth_params.merge(:format => 'json')
    end
  end

  context "format" do
    it "should accept json" do
      get action, auth_params.merge(:format => 'json')
      expect(response.code).to eq("200")
    end
    it "should return 406 not acceptable for html" do
      get action, auth_params.merge(:format => 'html')
      expect(response.code).to eq("406")
    end
    it "should return 406 not acceptable for xml" do
      get action, auth_params.merge(:format => 'xml')
      expect(response.code).to eq("406")
    end
  end

end