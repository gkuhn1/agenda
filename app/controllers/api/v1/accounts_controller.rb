class Api::V1::AccountsController < Api::V1::ApiController

  def current
    @account = current_account
    render :show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :description, :address, :phone, :phone2, :website, :plan, user_ids: [])
    end

end
