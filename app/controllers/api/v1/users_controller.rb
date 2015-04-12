class Api::V1::UsersController < Api::V1::ApiController

  skip_before_filter :authenticate, :account_required, :user_required, only: :login

  # Index
  api :GET, '/users', 'Lista usuários da conta logada'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  [
    {
      "id":"5505a29e676b7554a7010000",
      "name":"Zeca",
      "email":"zeca@gmail.com",
      "admin":true,
      "token":"J7s4coV-d_Y2XZygztps",
      "accounts":[{
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
      },{...}],
      "gravatar_url":"https://secure.gravatar.com/avatar/d99b817adea899880d8638bbe997ac0b.png?r=PG"
    }
  ]
  EOS
  def index
    super
  end

  # Show
  api :GET, '/users/:user_id', 'Busca informações sobre um único usuário'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  {
    "id":"552997ca676b750e74000000",
    "name":"Zeca Pereira",
    "email":"zeca@agenda.com",
    "admin":false,
    "token":"LAe9NGUCEQHizLxd3CDK",
    "accounts":[
      {
        "id":"552997ca676b750e74010000",
        "name":"Salão do Zeca",
        "description":null,
        "address":null,
        "phone":null,
        "phone2":null,
        "website":null,
        "plan":null,
        "created_at":"2015-04-11T18:53:14.347-03:00",
        "updated_at":"2015-04-11T18:53:14.347-03:00",
        "user_ids":[
          "552997ca676b750e74000000"
        ]
      }
    ],
    "gravatar_url":"https://secure.gravatar.com/avatar/f35eaa580eb1276b9f487cd618d0e141.png?r=PG"
  }
  EOS
  def show
    super
  end

  # New
  api :GET, '/users/new', 'Busca informações para criação de um novo usuário'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  {
    "id": "5529a35c676b752440000000",
    "name": "",
    "email": "",
    "admin": false,
    "token": null,
    "accounts": [],
    "gravatar_url": "https://secure.gravatar.com/avatar/d41d8cd98f00b204e9800998ecf8427e.png?r=PG"
  }
====Retorno com Erro:
  HTTP Status: 401
  {
    "error": "Unauthorized"
  }
  EOS
  def new
    super
  end

  def create
    super
  end

  # New
  api :GET, '/users/:user_id/edit', 'Busca informações de um usuário da conta autenticada para edição'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  {
    "id": "552997ca676b750e74000000",
    "name": "Zeca Pereira",
    "email": "zeca@agenda.com",
    "admin": false,
    "token": "LAe9NGUCEQHizLxd3CDK",
    "accounts": [{
        "id": "552997ca676b750e74010000",
        "name": "Salão do Zeca",
        "description": null,
        "address": null,
        "phone": null,
        "phone2": null,
        "website": null,
        "plan": null,
        "created_at": "2015-04-11T18:53:14.347-03:00",
        "updated_at": "2015-04-11T18:53:14.347-03:00",
        "user_ids": ["552997ca676b750e74000000"]
    }],
    "gravatar_url": "https://secure.gravatar.com/avatar/f35eaa580eb1276b9f487cd618d0e141.png?r=PG"
  }
====Retorno com erro por não encontrar o usuário:
  HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  def edit
    super
  end

  def update
    super
  end

  # New
  api :DELETE, '/users/:user_id', 'Exclui um usuário da conta autenticada.'
  description <<-EOS
===Requisição
Caso este usuário estar incluido em mais de uma conta, será apenas retirado a permissão de acesso a conta autenticada.
====Retorno com Sucesso:
  HTTP Status: 204
  {}
====Retorno com erro por não encontrar o usuário:
  HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  def destroy
    super
  end

  # login
  api :POST, '/users/login', 'Busca as informações de um usuário com base em e-mail e password'
  description <<-EOS
===Requisição
Para acesso a este endpoint não é necessária autenticação
====Retorno com Sucesso: Dados do usuário logado
HTTP Status: 200
  {
    "id": "552997ca676b750e74000000",
    "name": "Zeca Pereira",
    "email": "zeca@agenda.com",
    "admin": false,
    "token": "LAe9NGUCEQHizLxd3CDK",
    "accounts": [{
        "id": "552997ca676b750e74010000",
        "name": "Salão do Zeca",
        "description": null,
        "address": null,
        "phone": null,
        "phone2": null,
        "website": null,
        "plan": null,
        "created_at": "2015-04-11T18:53:14.347-03:00",
        "updated_at": "2015-04-11T18:53:14.347-03:00",
        "user_ids": ["552997ca676b750e74000000"]
    }],
    "gravatar_url": "https://secure.gravatar.com/avatar/f35eaa580eb1276b9f487cd618d0e141.png?r=PG"
  }
==== Retorno de erro:
HTTP Status: 422
  {"error":"Dados inválidos"}
  EOS
  param :email, String, "Email do usuário cadastrado", :required => true
  param :password, String, "Senha do usuário para login", :required => true
  def login
    @user = User.where(email: params[:email]).first
    return render :show if @user and @user.valid_password?(params[:password])
    render :json => {:error => "Dados inválidos"}, :status => 422
  end

  # login
  api :POST, '/users/current', 'Busca as informações do usuário autenticado por basic auth'
  description <<-EOS
===Requisição
====Retorno com Sucesso: Dados do usuário logado
HTTP Status: 200
  {
    "id": "552997ca676b750e74000000",
    "name": "Zeca Pereira",
    "email": "zeca@agenda.com",
    "admin": false,
    "token": "LAe9NGUCEQHizLxd3CDK",
    "accounts": [{
        "id": "552997ca676b750e74010000",
        "name": "Salão do Zeca",
        "description": null,
        "address": null,
        "phone": null,
        "phone2": null,
        "website": null,
        "plan": null,
        "created_at": "2015-04-11T18:53:14.347-03:00",
        "updated_at": "2015-04-11T18:53:14.347-03:00",
        "user_ids": ["552997ca676b750e74000000"]
    }],
    "gravatar_url": "https://secure.gravatar.com/avatar/f35eaa580eb1276b9f487cd618d0e141.png?r=PG"
  }
==== Retorno de erro:
HTTP Status: 401
  {
    "error": "Unauthorized"
  }
  EOS
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
