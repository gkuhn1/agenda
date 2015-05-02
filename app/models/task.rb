class Task
  include Mongoid::Document
  include Mongoid::Timestamps

  include Jsonable

  field :title, type: String
  field :description, type: String
  field :where, type: String
  field :status, type: Integer
  field :start_at, type: Time
  field :end_at, type: Time

  belongs_to :calendar
  belongs_to :created_by, class_name: 'User'
  has_and_belongs_to_many :specialties

  STATUS = {
    1 => "Criado"
  }

  validates_presence_of :title, :start_at, :end_at, :calendar
  validates :status, :inclusion => {:in => STATUS.keys, :message => 'situação desconhecida.' }

  before_validation :set_status
  after_create :create_notification
  after_create :send_task_add_notification

  def status!
    STATUS[self.status]
  end

  def set_status
    self.status = 1 if self.status.nil?
  end

  def f_start_at(format=:short)
    self.start_at.strftime(I18n.t format, scope: [:time, :formats])
  end

  def f_end_at(format=:short)
    self.end_at.strftime(I18n.t format, scope: [:time, :formats])
  end

  # NOTIFICATIONS
  def create_notification
    # se o criador for diferente do usuário para qual a tarefa é direcionada
    if self.calendar.user != self.created_by
      # manda notificação para o usuário do calendário
      NotifyWorker.perform_async(self.calendar.user.id, 'Novo agendamento', "#{f_start_at} até #{f_end_at}")
    end
  end

  def send_task_add_notification
    TasksWorker.perform_async(self.id)
  end

end
