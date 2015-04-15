class Api::V1::AccountsController < Api::V1::ApiController

  skip_before_filter :authenticate, :account_required, :user_required, only: :create

  resource_description do
    short  'Recursos para manipulação de contas do usuário autenticada'
    name 'Contas'
    formats ['json']
  end

  # Index
  api :GET, '/accounts', 'Lista accounts do usuário logado'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
[
  {
    "id":"55060f26676b750ec5000000",
    "name":"Salão do Zeca",
    "description":"Salão de beleza do Zeca",
    "address":"Rua Alameda, 161 Sala 24",
    "phone":"1199999999",
    "phone2":"119999998",
    "website":"www.meuwebsite.com",
    "plan":10,
    "created_at":"2015-03-15T20:01:18.485-03:00",
    "updated_at":"2015-04-10T23:17:59.903-03:00",
    "user_ids":[
      "5505a29e676b7554a7010000"
    ]
  }
]
  EOS

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
      params.require(:account).permit(:name, :description, :address, :phone, :phone2, :website, :plan, user_attributes: [:name, :email, :password, :password_confirmation], user_ids: [])
    end

end
