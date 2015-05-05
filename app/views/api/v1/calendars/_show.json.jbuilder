
json.id calendar.id
json.is_public calendar.is_public
json.system_notify calendar.system_notify
json.email_notify calendar.email_notify

if @tasks
  json.tasks do
    json.array!(calendar.filter_tasks(task_filter_params), partial: 'api/v1/tasks/show', as: :task)
  end
  json.account_tasks do
    json.array!(current_account.filter_tasks(task_filter_params), partial: 'api/v1/tasks/show', as: :task)
  end
end

json.user do
  json.partial! 'api/v1/users/show', :user => calendar.user
end