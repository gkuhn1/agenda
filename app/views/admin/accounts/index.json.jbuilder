json.array!(@accounts) do |account|
  json.extract! account, :name, :id, :description, :address, :phone, :phone2, :website, :plan
end
