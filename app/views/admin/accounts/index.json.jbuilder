json.array!(@accounts) do |account|
  json.partial! 'show', :account => account
end
