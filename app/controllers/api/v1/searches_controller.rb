class Api::V1::SearchesController < Api::V1::ApiController

  # Index
  api :GET, '/searches', 'Busca em agendas públicas'
  description <<-EOS
====Requisição
Accept: application/json
Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

====== Parâmetros de filtros aceitos

  {
    "specialty_id": "5574c51e655ff1318000000",
    "start_at": "2015-06-07T19:00:00.000-03:00",
    "end_at": "2015-06-07T19:30:00.000-03:00"
  }

====Retorno com Sucesso:
  [
    {
      "id":"5574c51e676b751318000000",
      "name":"HairStyle Salão",
      "description":null,
      "address":null,
      "phone":null,
      "phone2":null,
      "website":null,
      "plan":null,
      "created_at":"2015-06-07T19:26:38.916-03:00",
      "updated_at":"2015-06-20T23:02:46.464-03:00",
      "account_users":[{"_id":"5574c51e676b751318030000",
      "created_at":"2015-06-07T19:26:38.974-03:00",
      "has_calendar":true,
      "permission":"owner",
      "task_color":"#909090",
      "updated_at":"2015-06-07T19:26:38.974-03:00",
      "user_id":"5574c51e676b751318010000"
    }, {...}
  ]
  EOS
  def index
    # Retorna contas
    search_filter = SearchValidator.new search_filters
    if search_filter.valid?

      # Buscar contas que possuam a especialidade filtrada
      accounts = Specialty.where(id: params[:specialty_id]).map(&:account).flatten
      # Mapear os calendarios dessas contas
      calendars = accounts.map{|a| a.users.to_a }.flatten.map(&:calendar).keep_if { |c| c.date_available?(search_filters) }
      # se informado periodo de data verificar se o calendario possui data disponível para o periodo informado
      @accounts = Account.where(:id.in => calendars.map(&:user).map {|u| u.accounts.to_a }.flatten.uniq.map(&:id))

    else
      render json: {errors: search_filter.errors}, status: :unprocessable_entity
    end
  end

  # specialties
  api :GET, '/searches/specialties', 'Retorna a lista de especialidades existente'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  [
    {
      "id": "553c2542676b750ee5000000",
      "description": "Manicure",
      "active": true
    },
    {
      "id": "553c412e676b750ee40a0000",
      "description": "Especialidade 01",
      "active": true
    }
  ]
  EOS
  def specialties
    @specialties = Specialty.actives
  end


  # Show
  api :POST, '/searches/new_task', 'Cria uma nova tarefa para a conta de id informado'
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
  def new_task
    @task = Task.new task_current_user_params
    respond_to do |format|
      if @task.save
        @task_other = Task.create(task_other_user_params)
        format.json { render :new_task, status: :created }
      else
        format.json { render json: {errors: @task_other.errors}, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_current_user_params
      t_params = params.fetch(:task, {}).permit(:title, :specialty_id, :description, :where, :start_at, :end_at)
      t_params[:created_by] = current_user
      t_params[:calendar_id] = current_user.calendar.id
      t_params
    end

    def task_other_user_params
      t_params = params.fetch(:task, {}).permit(:title, :account_id, :specialty_id, :description, :where, :start_at, :end_at)
      t_params[:created_by] = current_user
      t_params
    end

    def search_filters
      params.permit(:specialty_id, :start_at, :end_at)
    end


end
