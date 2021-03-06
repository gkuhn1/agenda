class Api::V1::UsersController < Api::V1::ApiController

  skip_before_filter :authenticate, :account_required, :user_required, only: :login

  resource_description do
    short  'Recursos para manipulação de usuários da conta autenticada'
    name 'Usuários'
    formats ['json']
  end

  def_param_group :user do
    param :name, String, "Nome completo do usuário", :required => true
    param :email, String, "Endereço de e-mail válido", :required => true
    param :password, String, "Senha que o usuário irá utilizar para logar no aplicativo", :required => false
    param :password_confirmation, String, "Confirmação de senha", :required => false
    param :generate_password, Boolean, "Gerar um password aleatório para o usuário e enviar para o e-mail cadastrado.", :required => false, :default => false
    param :task_color, String, "Cor padrão para as tarefas deste usuário na conta autenticada.", :require => false, :default => "#909090"
    param :permission, AccountUser::PERMISSIONS.keys, "Permissão padrão para este usuário na conta autenticada.", :required => false, :default => "owner"
    param :has_calendar, Boolean, "Indica se o sistema permitira controle de agenda para este usuário na conta autenticada.", :required => false, :default => true
  end

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
      "gravatar_url":"https://secure.gravatar.com/avatar/d99b817adea899880d8638bbe997ac0b.png?r=PG",
      "task_color": "#909090",
      "permission": "owner",
      "has_calendar": true
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
    "gravatar_url":"https://secure.gravatar.com/avatar/f35eaa580eb1276b9f487cd618d0e141.png?r=PG",
    "task_color": "#909090",
    "permission": "owner",
    "has_calendar": true
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

  api :POST, '/users', 'Cria um novo usuário associado a conta autenticada'
  description <<-EOS
===Requisição
  Cria um novo usuário com as informações passadas, retornando código HTTP 200 OK em caso de sucesso ou 422 em caso de erro de validação dos dados, com a descrição dos errors

==== Exemplo de requisição para criação de dados de usuário
  {
    "name": "Zeca Pereira Atualizado",
    "email": "zeca@novoemail.com",
  }

====Retorno com Sucesso:
Dados do usuário criado
  {
    "id": "552997ca676b750e74000000",
    "name": "Zeca Pereira Atualizado",
    "email": "zeca@novoemail.com",
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
    "gravatar_url": "https://secure.gravatar.com/avatar/f35eaa580eb1276b9f487cd618d0e141.png?r=PG",
    "task_color": "#909090",
    "permission": "owner",
    "has_calendar": true
  }

====Retorno com erro por dados incorretos:
HTTP Status: 422
  {
    "errors": {
        "email": ["já está em uso"]
    }
  }
  EOS
  param_group :user
  def create
    object = get_model.new(self.send(self.controller_name.singularize + "_params"))
    instance_variable_set(get_variable, object)

    respond_to do |format|
      if instance_variable_get(get_variable).save
        account_user = current_account.add_user(@user)
        account_user.update_attributes(user_account_params)

        format.html { redirect_to "/" + self.controller_path, notice: "Registro criado com sucesso" }
        format.json { render :show, status: :created }
      else
        format.html { render :new }
        format.json { render json: {errors: instance_variable_get(get_variable).errors}, status: :unprocessable_entity }
      end
    end
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
    "gravatar_url": "https://secure.gravatar.com/avatar/f35eaa580eb1276b9f487cd618d0e141.png?r=PG",
    "task_color": "#909090",
    "permission": "owner",
    "has_calendar": true
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

  api :PUT, '/users/:user_id', 'Atualiza as informações de um usuário'
  description <<-EOS
===Requisição
  Atualiza as informações do usuário, retornando código HTTP 200 OK em caso de sucesso ou 422 em caso de erro de validação dos dados, com a descrição dos errors

==== Exemplo de requisição para atualização de dados de usuário
  {
    "name": "Zeca Pereira Atualizado",
    "email": "zeca@novoemail.com",
  }

====Retorno com Sucesso:
  {
    "id": "552997ca676b750e74000000",
    "name": "Zeca Pereira Atualizado",
    "email": "zeca@novoemail.com",
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
    "gravatar_url": "https://secure.gravatar.com/avatar/f35eaa580eb1276b9f487cd618d0e141.png?r=PG",
    "task_color": "#909090",
    "permission": "owner",
    "has_calendar": true
  }

====Retorno com erro por dados incorretos:
HTTP Status: 422
  {
    "errors": {
        "email": ["não é válido"]
    }
  }
  EOS
  param_group :user
  def update
    object = get_object or return
    instance_variable_set(get_variable, object)

    respond_to do |format|
      if instance_variable_get(get_variable).update(self.send(self.controller_name.singularize + "_params"))
        object.account_user_for(current_account).update_attributes(user_account_params)
        format.html { redirect_to "/" + self.controller_path, notice: "Registro atualizado com sucesso" }
        format.json { render :show, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: {errors: instance_variable_get(get_variable).errors}, status: :unprocessable_entity }
      end
    end
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
    "id": "552dbb03676b7517c9020000",
    "name": "Zeca Pereira Atualizado",
    "email": "novo2@gmail.com",
    "admin": false,
    "token": "wLpJt7oDiqpNkShRBzP2",
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
        "user_ids": ["552997ca676b750e74000000","552dbb03676b7517c9020000"]
    }],
    "gravatar_url": "https://secure.gravatar.com/avatar/9743a57ddb072edd7d17abe86c3d8e73.png?r=PG"
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

  # current
  api :GET, '/users/current', 'Busca as informações do usuário autenticado por basic auth'
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

  api :GET, '/users/all', 'Busca informações sobre um determinado usuário na base de dados global'
  description <<-EOS
===Requisição
====Retorno com Sucesso: Dados do usuário encontrado
HTTP Status: 200
  {
    "id": "552997ca676b750e74000000",
    "email": "zeca@agenda.com"
  }
==== Retorno de erro:
HTTP Status: 404
  {
    "error": "Not Found"
  }
  EOS
  def all
    email = user_all_params[:email]
    raise ActionController::ParameterMissing if email.blank?
    @user = User.where(email: email).first
    raise Mongoid::Errors::DocumentNotFound.new(User,{email: email}) if @user.nil?
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :name, :email, :password, :password_confirmation,
        :generate_password)
    end

    def user_all_params
      params.permit(:email)
    end

    def user_account_params
      params.require(:user).permit(:task_color, :permission, :has_calendar)
    end

    def get_collection
      current_account.users
    end
end
