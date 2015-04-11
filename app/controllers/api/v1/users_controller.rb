class Api::V1::UsersController < Api::V1::ApiController

  skip_before_filter :authenticate, :account_required, :user_required, only: :login

  api :GET, '/users', 'Lista usuários da conta logada'
  description <<-EOS
====Requisição
  'curl -u "[user_token]:[account.id]" -X GET -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/api/v1 --basic'
====Retorno com Sucesso:
=====Cabeçalho
    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8
    Date: Wed, 26 Jan 2011 12:56:01 GMT

=====Retorno
    {"status":"Authenticated"}

====Resposta com Erro:
=====Cabeçalho
      HTTP/1.1 401 Unauthorized
      Date: Mon, 17 Jan 2011 19:54:21 GMT
      Content-Type: application/json; charset=utf-8

=====Retorno
      {"error":"Unauthorized"}
  EOS


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
