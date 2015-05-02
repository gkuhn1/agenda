FactoryGirl.define do
  factory :task do
    title "My Task"
    description "My Task description"
    where "My task location"
    status 1
    start_at "2015-04-18 10:09:41"
    end_at "2015-04-18 10:09:41"
    calendar
    created_by factory: :user
  end

end
