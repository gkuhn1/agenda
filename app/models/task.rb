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

  validates_presence_of :title, :status, :start_at, :end_at, :calendar
  validates :status, :inclusion => {:in => STATUS.keys, :message => 'situação desconhecida.' }, if: 'errors[:status].blank?'

  def status!
    STATUS[self.status]
  end

end
