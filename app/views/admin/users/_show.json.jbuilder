json.id user.id
json.name user.name
json.email user.email
json.admin user.admin
json.token user.token
json.accounts user.accounts, partial: 'api/v1/accounts/show', as: :account
json.gravatar_url user.gravatar_url