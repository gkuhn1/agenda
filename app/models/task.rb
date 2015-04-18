class Task
  include Mongoid::Document

  field :title, type: String
  field :description, type: String
  field :where, type: String
  field :status, type: Integer
  field :start_at, type: Time
  field :end_at, type: Time

  embedded_in :calendar

  STATUS = {
    1 => "Criado"
  }

  validates_presence_of :title, :start_at, :end_at, :calendar
  validates :status, :inclusion => {:in => STATUS.keys, :message => 'situação desconhecida.' }

  before_validation :set_status

  def status!
    STATUS[self.status]
  end

  def set_status
    self.status = 1 if self.status.nil?
  end

end
