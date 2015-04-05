class HomepagesController < ApplicationController

  skip_before_filter :account_required, only: [:select_account, :index]
  skip_before_action :authenticate_user!, only: :index

  # Dashboard
  def index
  end

end
