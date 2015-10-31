class Api::V1::NotificationsController < Api::V1::ApiController

  # Index
  api :GET, '/notifications', 'Lista as notificações do usuário autenticado'
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
    @notifications = get_collection
    @reads = @notifications.reads
    @unreads = @notifications.unreads
  end

  # Show
  api :PUT, '/notifications/:id/mark_as_read', 'Marca uma notificação como lida'
  description <<-EOS
====Requisição
====Retorno com Sucesso:
  {
    "id": "55419e98676b752573000000",
    "text": "teste",
    "read": true,
    "read_at": "2015-04-30T00:17:40.374-03:00"
  }
  EOS
  def mark_as_read
    @notification = get_object
    @notification.mark_as_read
    render :show
  end

  # Show
  api :PUT, '/notifications/:id/mark_as_unread', 'Marca uma notificação como não lida'
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
  def mark_as_unread
    @notification = get_object
    @notification.mark_as_unread
    render :show
  end

  private

    def get_collection
      current_user.notifications.sys
    end

end
