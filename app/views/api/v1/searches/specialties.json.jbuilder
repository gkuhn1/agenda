json.array!(@specialties) do |specialty|
  json.partial! 'api/v1/specialties/show', :specialty => specialty
end