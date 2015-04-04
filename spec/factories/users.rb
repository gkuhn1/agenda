FactoryGirl.define do

  sequence(:user_email) { |n| "my-user-email#{n}@example.com" }

  factory :user do
    name "My User 1"
    email { generate(:user_email) }
    password "mypassword"
  end

end
