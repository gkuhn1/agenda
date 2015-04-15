class Api::V1::ApiController < ApplicationController
  include OnlyJson

  resource_description do
    short  'Autenticação da conta do usuário'
    name "Autenticação"
    formats ['json']
  end

  api :GET, '/', 'Endpoint de testes de autenticação'
  desc <<-EOS
  * Valida as credenciais de uma conta do usuário
  * Não recebe parâmetros
====Requisição

Exemplo de chamada API autenticada (onde 7ezUPAqq8T1ny0w1bSXr é o authentication_token do usuário e 55060f26676b750ec5000000 é o identificador da conta a ser autenticada):

Exemplo de Requisição utilizando o comando curl

  'curl -u "7ezUPAqq8T1ny0w1bSXr:55060f26676b750ec5000000" -X GET -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/api/v1 --basic'
====Retorno com Sucesso:
=====Cabeçalho
    HTTP/1.1 200 OK
    Content-Type: application/json; charset=utf-8
    Date: Wed, 26 Jan 2011 12:56:01 GMT

=====Retorno
    {"status":"Authenticated"}

====Resposta com Erro:
=====Cabeçalho
      HTTP/1.1 401 Unauthorized
      Date: Mon, 17 Jan 2011 19:54:21 GMT
      Content-Type: application/json; charset=utf-8

=====Retorno
      {"error":"Unauthorized"}
  EOS
  def endpoint
    render :json => {'status' => 'Authenticated'}, :status => 200, :location => api_v1_root_url
  end
end