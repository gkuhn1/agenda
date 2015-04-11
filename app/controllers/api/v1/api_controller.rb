class Api::V1::ApiController < ApplicationController
  include OnlyJson

  api :GET, '/', 'Endpoint de testes de autenticação'
  description <<-EOS
====Requisição
  'curl -u "[user_token]:[account.id]" -X GET -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/api/v1 --basic'
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