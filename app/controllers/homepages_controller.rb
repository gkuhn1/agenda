class HomepagesController < ApplicationController

  skip_before_filter :authenticate, :account_required, :user_required, only: :index

  def index
  end

end
