class Api::V1::UsersController < Api::V1::ApiController

  skip_before_filter :require_current_account, only: :login
  skip_before_filter :account_required, only: :login
  skip_before_filter :authenticate_user_from_token!, only: :login


  def login
    @user = User.where(email: params[:email]).first
    return render :show if @user and @user.valid_password?(params[:password])
    render :json => {:error => "Dados inválidos"}, :status => 422
  end

  def current
    @user = current_user
    render :show
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :name, :email, :admin,
        :password, :password_confirmation, :generate_password)
    end

    def get_collection
      current_account.users
    end
end
