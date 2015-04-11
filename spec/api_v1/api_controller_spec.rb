require 'rails_helper'

RSpec.describe Api::V1::ApiController, type: :controller do


  context "#endpoint" do
    it_behaves_like "require current_account" do
      let(:action) {:endpoint}
      let(:method) {:get}
      let(:success_status) { "200" }
    end

    it_behaves_like "require current_user" do
      let(:action) {:endpoint}
      let(:method) {:get}
      let(:success_status) { "200" }
    end
  end

end