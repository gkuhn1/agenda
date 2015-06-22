class Api::V1::AccountsController < Api::V1::ApiController

  skip_before_filter :authenticate, :account_required, :user_required, only: :create

  resource_description do
    short  'Recursos para manipulação de contas do usuário autenticada'
    name 'Contas'
    formats ['json']
  end

  # Index
  api :GET, '/accounts', 'Lista as contas a que o usuário logado tem acesso'
  description <<-EOS
====Requisição
Accept: application/json
Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

====Retorno com Sucesso:
  [{
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
    "user_ids": ["552997ca676b750e74000000", "552dbb03676b7517c9020000", "552dbbaf676b7517c9030000", "552dbbd7676b7517c9040000", "552dc116676b751afe000000"]
  }]
  EOS
  def index
    super
  end

  # Show
  api :GET, '/accounts/:account_id', 'Busca informações sobre uma conta específica'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  {
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
    "user_ids": ["552997ca676b750e74000000", "552dbb03676b7517c9020000", "552dbbaf676b7517c9030000", "552dbbd7676b7517c9040000", "552dc116676b751afe000000"]
  }
  EOS
  def show
    super
  end

  # New
  api :GET, '/accounts/new', 'Busca informações para criação de uma nova conta'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  {
    "id": "552fd6a3676b7520e2000000",
    "name": null,
    "description": null,
    "address": null,
    "phone": null,
    "phone2": null,
    "website": null,
    "plan": null,
    "created_at": null,
    "updated_at": null,
    "user_ids": []
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

  api :POST, '/accounts', 'Cria uma nova conta'
  description <<-EOS
===Requisição

*Não é necessário autenticação para acesso a este serviço*! Pode ser usado para criar novos registros no aplicativo.

Cria uma nova conta com as informações passadas, retornando código HTTP 200 OK em caso de sucesso ou 422 em caso de erro de validação dos dados, com a descrição dos errors.
É possivel incluir o parâmetro *user_attributes* para que juntamente com a criação da conta, crie-se um novo usuário.

===== Exemplo de requisição para criação de dados de conta com usuário já cadastrado
  {
    "account": {
      "name": "Nova conta",
      "user_ids": ["552fd6a3699b7520e2000000", "552fd6a3645b7520e2000000"]
    }
  }

===== Exemplo de requisição para criação de dados de conta com parâmetros para cadastrar um novo usuário
  {
    "account": {
      "name": "Nova conta",
      "user_attributes": {
        "name": "Zeca Pereira Atualizado",
        "email": "zeca@novoemail2.com"
        "password": "mypassword",
        "confirmation_password": "mypassword"
      }
    }
  }

====Retorno com Sucesso:
Dados da conta criada
  {
    "id": "552fdcad676b7520e2020000",
    "name": "Nova conta",
    "description": null,
    "address": null,
    "phone": null,
    "phone2": null,
    "website": null,
    "plan": null,
    "created_at": "2015-04-16T13:00:45.373-03:00",
    "updated_at": "2015-04-16T13:00:45.373-03:00",
    "user_ids": ["552fdcad676b7520e2010000"]
  }

====Retorno com erro por dados incorretos:
HTTP Status: 422
  {
    "errors": {
        "name": ["não pode ficar em branco"],
        "user_ids": ["não pode ficar em branco"]
    }
  }
  EOS
  param :name, String, "Nome para a conta a ser criada", :required => true
  param :description, String, "Descrição longa para a conta", :required => false
  param :address, String, "Endereço do local de atendimento quando houver", :required => false
  param :phone, String, "Telefone principal", :required => false
  param :phone2, String, "Telefone secundário", :required => false
  param :website, String, "Website", :required => false
  param :user_attributes, Hash, "Parâmetros do usuário que deverá ser criado e associado a nova conta. Os parâmetros são os mesmos aceitos na api de usuários"
  param :user_ids, Array, "Usuários que farão parte da conta", :required => false, :default => false
  see "users#create"
  def create
    super
  end

  # New
  api :GET, '/accounts/:account_id/edit', 'Busca informações de uma conta que o usuário autenticado possui acesso para edição'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  {
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
    "user_ids": ["552997ca676b750e74000000", "552dbb03676b7517c9020000", "552dbbaf676b7517c9030000", "552dbbd7676b7517c9040000", "552dc116676b751afe000000"]
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

  api :PUT, '/accounts/:account_id', 'Atualiza as informações de uma conta que o usuário autenticado possui acesso'
  description <<-EOS
===Requisição

Atualiza os dados de uma conta existente com as informações passadas, retornando código HTTP 200 OK em caso de sucesso ou 422 em caso de erro de validação dos dados, com a descrição dos errors.
Na atualização *não* é possivel criar novos usuários, porém pode-se manipular os usuários que possuem acesso a conta (+user_ids+)

===== Cabeçalho da requisição
  Accept: application/json
  Content-Type: application/json
  Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

===== Exemplo de requisição para alteração de dados de conta
  {
    "account": {
      "name": "Nova conta 2",
      "address": "Novo endereço",
      "phone": "11 987654321",
      "phone2": "11 123456789",
      "website": "https://www.google.com.br"
    }
  }

====Retorno com Sucesso:
Dados da conta alterada
  {
    "id": "552fdcad676b7520e2020000",
    "name": "Nova conta 2",
    "description": null,
    "address": "Novo endereço",
    "phone": "11 987654321",
    "phone2": "11 123456789",
    "website": "https://www.google.com.br"
    "plan": null,
    "created_at": "2015-04-16T13:00:45.373-03:00",
    "updated_at": "2015-04-16T13:00:45.373-03:00",
    "user_ids": ["552fdcad676b7520e2010000"]
  }

====Retorno com erro por dados incorretos:
HTTP Status: 422
  {
    "errors": {
        "name": ["não pode ficar em branco"],
        "user_ids": ["não pode ficar em branco"]
    }
  }

=== Retorno caso a conta não exista ou o usuário autenticado não possua acesso a ela:
HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  param :name, String, "Nome para a conta a ser criada", :required => true
  param :description, String, "Descrição longa para a conta", :required => false
  param :address, String, "Senha que o usuário irá utilizar para logar no aplicativo", :required => false
  param :phone, String, "Telefone principal", :required => false
  param :phone2, String, "Telefone secundário", :required => false
  param :website, String, "Website", :required => false
  param :user_attributes, Hash, "Parâmetros do usuário que deverá ser criado e associado a nova conta. Os parâmetros são os mesmos aceitos na api de usuários"
  param :user_ids, Array, "Usuários que farão parte da conta", :required => false, :default => false
  def update
    super
  end

  # New
  api :DELETE, '/accounts/:account_id', 'Exclui uma conta do usuário autenticado.'
  description <<-EOS
===Requisição
Apenas é possível excluir contas caso o usuário autenticado tenha acesso a essa conta.

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

  def current
    @account = current_account
    render :show
  end

  api :PUT, '/accounts/add_user', 'Adiciona um usuário existente a conta autenticada'
  description <<-EOS
  EOS
  def add_user
    @account_user = current_account.add_user(User.find(account_user_params[:user_id]))
    raise ActionController::ParameterMissing if @account_user.nil?
    @account_user.update_attributes(account_user_params)
  end

  api :DELETE, '/accounts/remove_user', 'Remove um usuário da conta autenticada'
  description <<-EOS
  EOS
  def remove_user
    current_account.account_users.destroy_all(user_id: params[:user_id])
    head :no_content
  end

  def get_collection
    current_user.accounts
  end

  private

    def account_user_params
      params.require(:user).permit(:user_id, :has_calendar, :permission, :task_color)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :description, :address, :phone, :phone2, :website, :plan, user_attributes: [:name, :email, :password, :password_confirmation])
    end

end
