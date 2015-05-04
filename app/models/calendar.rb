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
    begin
      if filters[:start_at] and filters[:end_at]
        start_at, end_at = [DateTime.parse(filters[:start_at]).utc, DateTime.parse(filters[:end_at]).utc]
        end_at += 1.day if end_at.hour == 0 and end_at.second == 0
        return tasks.where(:start_at.gt => start_at, :end_at.lt => end_at)
      end
    rescue ArgumentError => e
    end
    return tasks
  end


  def date_available?(filters)
    # Retorna true/false o calendario possui data disponivel para os filtros passados
    !filter_tasks(filters).any?
  end

end
