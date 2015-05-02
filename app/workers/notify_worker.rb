class NotifyWorker
  include Sidekiq::Worker

  def perform(user_id, title, text)
    user = User.find(user_id)
    notification = Notification.to(user, title, text)
    # push notification to pusher
    Pusher.trigger("#{user_id}_notifications", 'added', notification.to_json)
  end

end