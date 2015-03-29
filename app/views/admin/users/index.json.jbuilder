json.array!(@users) do |user|
  json.partial! 'show', :user => user
end
