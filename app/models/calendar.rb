class Calendar
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in database: ->{ Thread.current[:account].database }

  field :is_public, type: Mongoid::Boolean, default: false
  field :system_notify, type: Mongoid::Boolean, default: true
  field :email_notify, type: Mongoid::Boolean, default: true

  belongs_to :user
  validates_presence_of :user

end
