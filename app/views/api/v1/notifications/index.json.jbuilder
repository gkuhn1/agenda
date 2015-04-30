json.notifications do
  json.array!(@notifications) do |notification|
    json.partial! 'show', :notification => notification
  end
end
json.read_count @reads.count
json.unread_count @unreads.count
json.notifications_count @notifications.count