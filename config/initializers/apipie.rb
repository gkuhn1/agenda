Apipie.configure do |config|
  config.app_name                = "API Agenda"
  config.app_info                = <<-EOL
==CONTROLE DE ACESSO
A autenticação no Agenda é feita a partir de um "authentication_token" de um usuário e do "account_id" de uma conta.



==Introdução
Agenda possui uma API REST para interagir com seus recursos, através JSON sobre HTTP, usando todos principais verbos HTTP (GET, POST, PUT, DELETE). Cada recurso possui sua própria URL e pode ser manipulado de maneira isolada, tentando assim seguir os princípios REST ao máximo.

Autenticação
O método de autenticação usado é HTTP Basic (RFC2617) utilizando as credenciais fornecidas, via Https.
Todo acesso à API é feito do ponto de vista de um usuário existente. Assim sendo, toda requisição à API deverá ser autenticada. A autenticação é feita via HTTP Basic, porém ao invés de passar o login e senha do usuário, como é tradicional, deve-se fornecer o "authentication_token" do usuário (uma string de até 60 caracteres encontrada na página de perfil do usuário) no campo 'login' e o identificador da conta a qual se deseja acessar no campo 'password'.

O authentication_token é gerado automaticamente quando o usuário faz o seu cadastro no sistema e pode ser encontrado na página "Minhas informações".
O account_id também é gerado automaticamente assim que uma conta é criada e pode ser encontrado em "Configurações da conta".
A autenticação é necessária em todas as requisições.


==SERIALIZAÇÃO DE DADOS
Datas como date devem ser informadas para o formato ‘YYYY-MM-DD’ de acordo com a ISO8601

Datas como datetime devem ser informadas para o formato ‘YYYY-MM-DDTHH:MM:SS’ de acordo com a ISO8601

Timezone padrão utilizado: UTC
EOL
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apipie"
  config.process_params          = false
  config.validate                = false
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end


class Apipie::Application

  alias_method :orig_load_controller_from_file, :load_controller_from_file

  def load_controller_from_file(controller_file)
    begin
      orig_load_controller_from_file(controller_file)
    rescue LoadError => e
      controller_file.gsub(/\A.*\/app\/controllers\//,"").gsub(/\.\w*\Z/,"").gsub("concerns/","").camelize.constantize
    end
  end

end