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
  field :account_id, type: String
  field :specialty_id, type: String

  belongs_to :calendar
  belongs_to :created_by, class_name: 'User'
  has_and_belongs_to_many :specialties

  STATUS = {
    1 => "Criado"
  }

  validates_presence_of :title, :start_at, :end_at
  validates_presence_of :calendar, if: 'account_id.blank?'
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
    if !self.calendar.present? or self.calendar.user != self.created_by
      # manda notificação para o usuário do calendário
      if self.calendar.present?
        user_ids = [self.calendar.user.id]
      elsif self.account_id.present?
        user_ids = Account.find(self.account_id).users.map(&:id)
      else
        user_ids = []
      end

      user_ids.each do |user_id|
        NotifyWorker.perform_async(user_id, 'Novo agendamento', "#{f_start_at} até #{f_end_at}")
      end
    end
  end

  def send_task_add_notification
    TasksWorker.perform_async(self.id)
  end

end
