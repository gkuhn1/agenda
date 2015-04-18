class Api::V1::CalendarsController < Api::V1::ApiController

  resource_description do
    short  'Recursos para manipulação de Agendas'
    name 'Agendas'
    formats ['json']
  end

  # Index
  api :GET, '/calendars', 'Lista os calendarios que o usuário da agenda autenticada tem acesso'
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
  api :GET, '/calendars/:calendar_id', 'Busca informações sobre uma agenda específica'
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
  api :GET, '/calendars/new', 'Busca informações para criação de uma nova agenda'
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

  api :POST, '/calendars', 'Cria uma nova agenda'
  description <<-EOS
===Requisição

*Não é necessário autenticação para acesso a este serviço*! Pode ser usado para criar novos registros no aplicativo.

Cria uma nova agenda com as informações passadas, retornando código HTTP 200 OK em caso de sucesso ou 422 em caso de erro de validação dos dados, com a descrição dos errors.
É possivel incluir o parâmetro *user_attributes* para que juntamente com a criação da agenda, crie-se um novo usuário.

===== Exemplo de requisição para criação de dados de agenda com usuário já cadastrado
  {
    "account": {
      "name": "Nova agenda",
      "user_ids": ["552fd6a3699b7520e2000000", "552fd6a3645b7520e2000000"]
    }
  }

===== Exemplo de requisição para criação de dados de agenda com parâmetros para cadastrar um novo usuário
  {
    "account": {
      "name": "Nova agenda",
      "user_attributes": {
        "name": "Zeca Pereira Atualizado",
        "email": "zeca@novoemail2.com"
        "password": "mypassword",
        "confirmation_password": "mypassword"
      }
    }
  }

====Retorno com Sucesso:
Dados da agenda criada
  {
    "id": "552fdcad676b7520e2020000",
    "name": "Nova agenda",
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
  param :name, String, "Nome para a agenda a ser criada", :required => true
  param :description, String, "Descrição longa para a agenda", :required => false
  param :address, String, "Senha que o usuário irá utilizar para logar no aplicativo", :required => false
  param :phone, String, "Telefone principal", :required => false
  param :phone2, String, "Telefone secundário", :required => false
  param :website, String, "Website", :required => false
  param :user_attributes, Hash, "Parâmetros do usuário que deverá ser criado e associado a nova agenda. Os parâmetros são os mesmos aceitos na api de usuários"
  param :user_ids, Array, "Usuários que farão parte da agenda", :required => false, :default => false
  see "users#create"
  def create
    super
  end

  # New
  api :GET, '/calendars/:calendar_id/edit', 'Busca informações de uma agenda que o usuário autenticado possui acesso para edição'
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

  api :PUT, '/calendars/:calendar_id', 'Atualiza as informações de uma agenda que o usuário autenticado possui acesso'
  description <<-EOS
===Requisição

Atualiza os dados de uma agenda existente com as informações passadas, retornando código HTTP 200 OK em caso de sucesso ou 422 em caso de erro de validação dos dados, com a descrição dos errors.
Na atualização *não* é possivel criar novos usuários, porém pode-se manipular os usuários que possuem acesso a agenda (+user_ids+)

===== Cabeçalho da requisição
  Accept: application/json
  Content-Type: application/json
  Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

===== Exemplo de requisição para alteração de dados de agenda
  {
    "account": {
      "name": "Nova agenda 2",
      "address": "Novo endereço",
      "phone": "11 987654321",
      "phone2": "11 123456789",
      "website": "https://www.google.com.br"
    }
  }

====Retorno com Sucesso:
Dados da agenda alterada
  {
    "id": "552fdcad676b7520e2020000",
    "name": "Nova agenda 2",
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

=== Retorno caso a agenda não exista ou o usuário autenticado não possua acesso a ela:
HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  param :name, String, "Nome para a agenda a ser criada", :required => true
  param :description, String, "Descrição longa para a agenda", :required => false
  param :address, String, "Senha que o usuário irá utilizar para logar no aplicativo", :required => false
  param :phone, String, "Telefone principal", :required => false
  param :phone2, String, "Telefone secundário", :required => false
  param :website, String, "Website", :required => false
  param :user_attributes, Hash, "Parâmetros do usuário que deverá ser criado e associado a nova agenda. Os parâmetros são os mesmos aceitos na api de usuários"
  param :user_ids, Array, "Usuários que farão parte da agenda", :required => false, :default => false
  def update
    super
  end

  # New
  api :DELETE, '/calendars/:calendar_id', 'Exclui uma agenda do usuário autenticado.'
  description <<-EOS
===Requisição
Apenas é possível excluir agendas caso o usuário autenticado tenha acesso a essa agenda.

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

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:is_public, :system_notify, :email_notify, :user_id)
    end

end