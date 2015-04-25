
json.id user.id
json.name user.name
json.email user.email
json.admin user.admin
json.token user.token
json.accounts user.accounts, partial: 'api/v1/accounts/show', as: :account
json.gravatar_url user.gravatar_url

json.task_color user.account_user_for(current_account).task_color
json.permission user.account_user_for(current_account).permission
json.permission_desc user.account_user_for(current_account).permission!
json.has_calendar user.account_user_for(current_account).has_calendar