class HomepagesController < ApplicationController

  skip_before_filter :account_required, only: :select_account

  # Dashboard
  def index
  end

  def select_account
    @accounts = current_user.accounts
    params[:id] = @accounts.first if @accounts.count == 1
    if params[:id]
      session[:account_id] = params[:id] if @accounts.where(id: params[:id]).first.id
      redirect_to root_path
    end
  end

  private

    def layout_by_resource
      return "login" if params[:action] == 'select_account'
      "application"
    end


end
