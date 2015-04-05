class Api::V1::AccountsController < Api::V1::ApiController

  skip_before_filter :require_current_account, only: :create
  skip_before_filter :account_required, only: :create

  def current
    @account = current_account
    render :show
  end

  def get_collection
    current_user.accounts
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :description, :address, :phone, :phone2, :website, :plan, user_ids: [])
    end

end
