class Api::V1::NotificationsController < Api::V1::ApiController

  def index
    @notifications = get_collection
    @reads = @notifications.read
    @unreads = @notifications.unread
  end

  def mark_as_read
    @notification = get_object
    @notification.mark_as_read
    render :show
  end

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
