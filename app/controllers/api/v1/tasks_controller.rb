class Api::V1::TasksController < Api::V1::ApiController
  include RequireCalendar

  before_filter :set_calendar, :require_calendar

  resource_description do
    short  'Recursos para manipulação de tarefas'
    name 'Tarefas'
    formats ['json']
  end

  # Index
  api :GET, '/calendars/:calendar_id/tasks', 'Lista a tarefas de um calendario que o usuário autenticado tem acesso'
  description <<-EOS
====Requisição
Accept: application/json
Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

====Retorno com Sucesso:
  TODO
  EOS
  def index
    super
  end

  # Show
  api :GET, '/calendars/:calendar_id/tasks/:task_id', 'Busca informações completas sobre uma tarefa específica'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  TODO
  EOS
  def show
    super
  end

  # New
  api :GET, '/calendars/:calendar_id/tasks/new', 'Busca informações para criação de uma nova agenda'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  {
    "id": "5532e21d676b7518ca010000",
    "title": null,
    "description": null,
    "where": null,
    "status": null,
    "status_description": null,
    "start_at": null,
    "end_at": null
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

  api :POST, '/calendars/:calendar_id/tasks', 'Cria uma nova task para a agenda que foi passada'
  description <<-EOS
===Requisição


===== Exemplo de requisição para criação de dados de agenda com usuário já cadastrado
  {
    "task": {
      "id": "5532e21d676b7518ca010000",
      "title": "Corte de cabelo Masculino",
      "description": null,
      "where": "Salão",
      "start_at": "2015-04-18T10:00:00",
      "end_at": "2015-04-18T10:15:00"
    }
  }

====Retorno com Sucesso:
Dados da agenda criada
  {
    "id": "5532e323676b7518ca020000",
    "title": "Corte de cabelo Masculino",
    "description": null,
    "where": "Salão",
    "status": 1,
    "status_description": "Criado",
    "start_at": "2015-04-18T10:00:00.000-03:00",
    "end_at": "2015-04-18T10:15:00.000-03:00"
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
  api :GET, '/calendars/:calendar_id/tasks/:task_id/edit', 'Busca informações de uma tarefa para edição'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
  TODO
====Retorno com erro por não encontrar o usuário:
  HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  def edit
    super
  end

  api :PUT, '/calendars/:calendar_id/tasks/:task_id', 'Atualiza as informações de uma tarefa'
  description <<-EOS
===Requisição

TODO

===== Cabeçalho da requisição
  Accept: application/json
  Content-Type: application/json
  Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

===== Exemplo de requisição para alteração de dados de agenda
  TODO

====Retorno com Sucesso:
Dados da agenda alterada
  TODO

====Retorno com erro por dados incorretos:
HTTP Status: 422
  TODO

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
  api :DELETE, '/calendars/:calendar_id/tasks/:task_id', 'Exclui uma tarefa da agenda selecionada.'
  description <<-EOS
===Requisição
TODO

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
      current_calendar.tasks
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      t_params = params.require(:task).permit(:id, :title, :description, :where, :start_at, :end_at)
      t_params[:calendar] = current_calendar
      t_params
    end

end
