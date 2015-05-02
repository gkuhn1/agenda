class TasksWorker
  include Sidekiq::Worker

  def perform(task_id, action='added')
    task = Task.find(task_id)
    # push notification to pusher
    Pusher.trigger("#{task.calendar.user_id}_tasks", action, task.to_json)
  end

end