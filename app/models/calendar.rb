class Calendar
  include Mongoid::Document
  include Mongoid::Timestamps

  field :is_public, type: Mongoid::Boolean, default: false
  field :system_notify, type: Mongoid::Boolean, default: true
  field :email_notify, type: Mongoid::Boolean, default: true

  belongs_to :user
  validates_presence_of :user

  has_many :tasks

  def filter_tasks(filters)
    if filters[:start_at] and filters[:end_at]
      return tasks.where(:start_at.gt => filters[:start_at], :end_at.lt => filters[:end_at])
    else
      return tasks
    end
  end

end
