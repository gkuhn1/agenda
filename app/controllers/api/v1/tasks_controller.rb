class Api::V1::TasksController < Api::V1::ApiController

  resource_description do
    short  'Recursos para manipulação de tarefas'
    name 'Tarefas'
    formats ['json']
  end

  def_param_group :task do
    param :title, String, "Título da tarefa", :required => true
    param :description, String, "Descrição longa da tarefa", :required => false
    param :where, String, "Localização (pode ser um local ou um endereço) onde a tarefa será executada", :required => true
    param :start_at, String, "Data e Hora de inicio da tarefa *YYYY-MM-DDTHH:MM:SS*", :required => true
    param :end_at, String, "Data e Hora de fim da tarefa *YYYY-MM-DDTHH:MM:SS*", :required => true
  end

  # Index
  api :GET, '/tasks', 'Lista as tarefas de todos os calendarios da conta autenticada'
  description <<-EOS
====Requisição
Accept: application/json
Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

====Retorno com Sucesso:
  [
    {
      "id": "553d2a52676b751521000000",
      "calendar_id": "5532cc58676b752f23000000",
      "account_id": null,
      "title": "Corte de cabelo Masculino",
      "description": null,
      "where": "Salão",
      "status": 1,
      "status_description": "Criado",
      "start_at": "2015-04-18T10:00:00.000-03:00",
      "created_by_id": null,
      "end_at": "2015-04-18T10:15:00.000-03:00"
    },
    {
      "id": "553d2a52676b751521010000",
      "calendar_id": "5532cc58676b752f23000000",
      "account_id": null,
      "title": "Corte de cabelo Masculino",
      "description": "Descrição editada!",
      "where": "Localização editada!",
      "status": 1,
      "status_description": "Criado",
      "start_at": "2015-04-18T10:10:00.000-03:00",
      "created_by_id": null,
      "end_at": "2015-04-18T10:25:00.000-03:00"
    }
  ]
  EOS
  def index
    super
  end

  # Show
  api :GET, '/tasks/:task_id', 'Busca informações completas sobre uma tarefa específica'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  TODO
  EOS
  def show
    super
  end

  # New
  api :GET, '/tasks/new', 'Busca informações para criação de uma nova tarefa'
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

  api :POST, '/tasks', 'Cria uma nova tarefa para a agenda que foi passada'
  description <<-EOS
===Requisição


===== Exemplo de requisição com dados para criação de uma nova tarefa
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
Dados da tarefa criada
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
  param_group :task
  def create
    super
  end

  # New
  api :GET, '/tasks/:task_id/edit', 'Busca informações de uma tarefa para edição'
  description <<-EOS
===Requisição
====Retorno com Sucesso:
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
====Retorno com erro por não encontrar a tarefa:
  HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  def edit
    super
  end

  api :PUT, '/tasks/:task_id', 'Atualiza as informações de uma tarefa'
  description <<-EOS
===Requisição

TODO

===== Cabeçalho da requisição
  Accept: application/json
  Content-Type: application/json
  Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

===== Exemplo de requisição para alteração de dados de tarefa
{
  "task": {
    "id": "5532e323676b7518ca020000",
    "title": "Corte de cabelo Masculino",
    "description": "Descrição editada!",
    "where": "Localização editada!",
    "start_at": "2015-04-18T10:10:00:00",
    "end_at": "2015-04-18T10:25:00:00"
  }
}

====Retorno com Sucesso:
Dados da tarefa alterada
  {
    "id": "5532e323676b7518ca020000",
    "title": "Corte de cabelo Masculino",
    "description": "Descrição editada!",
    "where": "Localização editada!",
    "status": 1,
    "status_description": "Criado",
    "start_at": "2015-04-18T10:10:00.000-03:00",
    "end_at": "2015-04-18T10:25:00.000-03:00"
  }

====Retorno com erro por dados incorretos:
HTTP Status: 422
  {
    "errors":
    {
      "title":
      [
        "não pode ficar em branco"
      ]
    }
  }

=== Retorno caso a tarefa não exista ou o usuário autenticado não possua acesso a agenda a qual ela pertence:
HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  param_group :task
  def update
    super
  end

  # New
  api :DELETE, '/tasks/:task_id', 'Exclui uma tarefa da agenda selecionada.'
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
      tasks_ids = []
      current_account.calendars.each do |calendar|
        tasks_ids += calendar.filter_tasks(task_filter_params).map(&:id)
      end
      tasks_ids += current_account.filter_tasks(task_filter_params).map(&:id)
      Task.where(:id.in => tasks_ids)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      t_params = params.fetch(:task, {}).permit(:id, :title, :description, :where, :start_at, :end_at, :calendar_id)
      t_params[:created_by] = current_user
      t_params
    end

    def task_filter_params
      params.permit(:start_at, :end_at)
    end

end
