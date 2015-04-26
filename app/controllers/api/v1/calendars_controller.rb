class Api::V1::CalendarsController < Api::V1::ApiController

  resource_description do
    short  'Recursos para manipulação de Agendas'
    name 'Agendas'
    formats ['json']
  end

  # Index
  api :GET, '/calendars', 'Lista as agendas que o usuário da conta autenticada tem acesso'
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
    @tasks = params[:tasks]
    super
  end

  # Show
  api :GET, '/calendars/:id', 'Busca informações sobre uma agenda específica'
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

  # Edit
  api :GET, '/calendars/:id/edit', 'Busca informações de uma agenda que o usuário autenticado possui acesso para edição'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  {
    "id": "5532cc58676b752f23000000",
    "is_public": false
    "system_notify": true,
    "email_notify": true
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
  api :PUT, '/calendars/:id', 'Atualiza as informações de uma agenda que o usuário autenticado possui acesso'
  description <<-EOS
===Requisição

===== Cabeçalho da requisição
  Accept: application/json
  Content-Type: application/json
  Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

===== Exemplo de requisição para alteração de dados de agenda
  {
    "calendar": {
      "system_notify": false,
      "email_notify": true
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
  param :system_notify, Boolean, "Identifica se é para deve enviar notificações via sistema para o dono do calendário", :required => false
  param :email_notify, Boolean, "Identifica se é para deve enviar notificações por e-mail para o dono do calendário", :required => false
  def update
    super
  end

  private

    def get_collection
      current_account.calendars
    end

    def get_object
      # TODO
      # Calendar.where(id:params[:id]).and(get_collection.selector).find(params[:id])
      current_account.get_calendar(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:id, :system_notify, :email_notify)
    end

end
