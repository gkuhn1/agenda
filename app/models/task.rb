class Task
  include Mongoid::Document

  store_in database: ->{ Mongoid.current_database }

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

  validates :status, :inclusion => {:in => STATUS.keys, :message => 'situação desconhecida.' }

  def status!
    STATUS[self.status]
  end

end
