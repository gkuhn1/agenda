require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  it_behaves_like "api v1 controller" do
    let(:action) {:current}
  end

end
