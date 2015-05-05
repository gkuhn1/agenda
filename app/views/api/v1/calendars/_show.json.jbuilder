
json.id calendar.id
json.is_public calendar.is_public
json.system_notify calendar.system_notify
json.email_notify calendar.email_notify


json.user do
  json.partial! 'api/v1/users/show', :user => calendar.user
end