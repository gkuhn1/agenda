FactoryGirl.define do

  sequence(:user_email) { |n| "my-user-email#{n}@example.com" }
  sequence(:user_name) { |n| "My User #{n}"}

  factory :user do
    name  { generate(:user_name) }
    email { generate(:user_email) }
    password "mypassword"
  end

end
