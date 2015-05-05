class TasksWorker
  include Sidekiq::Worker

  def perform(task_id, action='added')
    task = Task.find(task_id)
    # push notification to pusher
    user_ids = task.affected_users.map(&:id)
    user_ids.each do |user_id|
      Pusher.trigger("#{user_id}_tasks", action, task.to_json)
    end
  end

end