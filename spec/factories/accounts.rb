FactoryGirl.define do
  factory :account do
    name "MyString"
    description "MyString"
    address "MyString"
    phone "MyString"
    phone2 "MyString"
    website "MyString"
    plan 1

    transient do
      user nil
    end

    after(:build) do |account, evaluator|
      account.add_user(evaluator.user.nil? ? FactoryGirl.create(:user) : evaluator.user)
    end
  end

end
