class Api::V1::SearchesController < Api::V1::ApiController

  # Index
  api :GET, '/searches', 'Busca'
  description <<-EOS
====Requisição
Accept: application/json
Authorization: Basic TEFlOU5HVUNFUUhpekx4ZDNDREs6NTUyOTk3Y2E2NzZiNzUwZTc0MDEwMDAw

====Retorno com Sucesso:
  {
    "notifications": [
      {
        "id": "55419e98676b752573000000",
        "text": "teste",
        "read": false,
        "read_at": null
      }
    ],
    "read_count": 3,
    "unread_count": 1,
    "notifications_count": 4
  }
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
  api :GET, '/searches/places', 'Retorna a lista de locais existente'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  {
    "id": "55419e98676b752573000000",
    "text": "teste",
    "read": false,
    "read_at": null
  }
  EOS
  def places
    # TODO
  end

  # Show
  api :POST, '/searches/new_task', 'Cria uma nova tarefa para a conta de id informado'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  {
    "id": "55419e98676b752573000000",
    "text": "teste",
    "read": false,
    "read_at": null
  }
  EOS
  def new_task
    @task = Task.new task_params
    respond_to do |format|
      if @task.save
        format.json { render :new_task, status: :created }
      else
        format.json { render json: {errors: @task.errors}, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      t_params = params.fetch(:task, {}).permit(:title, :account_id, :specialty_id, :description, :where, :start_at, :end_at)
      t_params[:created_by] = current_user
      t_params
    end

    def search_filters
      params.permit(:specialty_id, :start_at, :end_at)
    end


end
