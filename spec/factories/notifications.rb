FactoryGirl.define do

  factory :notification do
    title "Notification"
    text "Notification text"
    read false
    read_at nil
    type 1

    user nil

    factory :notification_read do
      read true
      read_at Time.now
    end

  end

end
