class Api::V1::SpecialtiesController < Api::V1::ApiController

  resource_description do
    short  'Recursos para manipulação de Especialidades'
    name 'Especialidades'
    formats ['json']
  end

  def_param_group :specialty do
    param :description, String, "Descrição da especialidade", :required => true
    param :active, Boolean, "Status ativo da especialidade", :required => false, :default => 'true'
  end


  # Index
  api :GET, '/specialties', 'Lista as especialidades cadastradas na conta autenticada'
  description <<-EOS
====Requisição
Accept: application/json
Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

=====Filtros de requisição
  tasks [true/false] - Exibir também as tarefas de cada celendário

====Retorno com Sucesso:
  [
    {
      "id": "5532cc58676b752f23000000",
      "is_public": false
      "system_notify": true,
      "email_notify": true
    }
  ]
  EOS
  def index
    super
  end

  # Show
  api :GET, '/specialties/:id', 'Busca informações sobre uma especialidade específica'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  {
    "id": "5532cc58676b752f23000000",
    "is_public": false
    "system_notify": true,
    "email_notify": true
  }
  EOS
  def show
    super
  end

  # New
  api :GET, '/specialties/new', 'Busca informações para criação de uma nova especialidade'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  {
    "id": "553c2542676b750ee4000000",
    "description": null,
    "active": true
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

  api :POST, '/specialties', 'Cria uma nova especialidade para a agenda autenticada'
  description <<-EOS
===Requisição


===== Exemplo de requisição com dados para criação de uma nova especialidade
  {
    "specialty": {
      "id": "553c2542676b750ee4000000",
      "description": "Manicure",
      "active": true
    }
  }

====Retorno com Sucesso:
Dados da especialidade criada
  {
    "id": "553c2542676b750ee4000000",
    "description": "Manicure",
    "active": true
  }

====Retorno com erro por dados incorretos:
HTTP Status: 422
  {
    "errors": {
        "description": ["não pode ficar em branco"]
    }
  }
  EOS
  param_group :specialty
  def create
    super
  end

  # Edit
  api :GET, '/specialties/:id/edit', 'Busca informações de uma especialidade para edição'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  {
    "id": "553c2542676b750ee4000000",
    "description": "Manicure",
    "active": true
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

  # update
  api :PUT, '/specialties/:id', 'Atualiza as informações de uma especialidade'
  description <<-EOS
===Requisição

===== Cabeçalho da requisição
  Accept: application/json
  Content-Type: application/json
  Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

===== Exemplo de requisição para alteração de dados de agenda
  {
    "specialty": {
      "id": "553c2542676b750ee4000000",
      "description": "Manicure",
      "active": false
    }
  }

====Retorno com Sucesso:
Dados da agenda alterada
  {
    "id": "5532cc58676b752f23000000",
    "is_public": false,
    "system_notify": false,
    "email_notify": true
  }

====Retorno com erro por dados incorretos:
HTTP Status: 422
  {
    "errors": {
    }
  }

=== Retorno caso a agenda não exista ou o usuário autenticado não possua acesso a ela:
HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  param_group :specialty
  def update
    super
  end

  # New
  api :DELETE, '/specialties/:id', 'Exclui uma especialidade.'
  description <<-EOS
===Requisição

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

    def get_collection
      current_account.specialties
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def specialty_params
      p = params.require(:specialty).permit(:id, :description, :active)
      p[:account] = current_account
      p
    end

end
