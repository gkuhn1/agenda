json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :description, :address, :phone, :phone2, :website, :plan
  json.url account_url(account, format: :json)
end
