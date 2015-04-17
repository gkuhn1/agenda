FactoryGirl.define do

  factory :calendar do
    is_public false
    system_notify false
    email_notify false

    user
  end

end
