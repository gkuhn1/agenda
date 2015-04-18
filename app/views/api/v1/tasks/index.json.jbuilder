json.array!(@tasks) do |task|
  json.partial! 'show', :task => task
end
