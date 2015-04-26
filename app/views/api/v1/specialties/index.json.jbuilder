json.array!(@specialties) do |specialty|
  json.partial! 'show', :specialty => specialty
end
