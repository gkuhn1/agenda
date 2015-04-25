class Admin::AccountsController < Admin::AdminController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:id, :name, :description, :address, :phone, :phone2, :website, :plan)
    end

end
