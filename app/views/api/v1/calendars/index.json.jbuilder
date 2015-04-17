json.array!(@calendars) do |calendar|
  json.partial! 'show', :calendar => calendar
end
