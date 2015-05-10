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
  field :account_user_id, type: String

  belongs_to :calendar
  belongs_to :created_by, class_name: 'User'
  has_and_belongs_to_many :specialties

  STATUS = {
    1 => "Aguardando confirmação",
    2 => "Confirmada",
    3 => "Cancelada"
  }

  validates_presence_of :title, :start_at, :end_at
  validates_presence_of :calendar, if: 'account_id.blank?'
  validates :status, :inclusion => {:in => STATUS.keys, :message => 'situação desconhecida.' }

  before_validation :set_status
  after_create :create_notification
  after_create :send_task_add_notification
  after_save :send_status_changed_notification

  def status!
    STATUS[self.status]
  end

  def set_status
    self.status = 1 if self.status.nil?
  end

  def color
    # retorna a cor de um evento
    if self.account_user_id.present?
      _id = BSON::ObjectId.from_string(self.account_user_id.to_s)
      account = Account.where('account_users._id' => _id).first
      account.account_users.find(_id).task_color
    end
  end

  def f_start_at(format=:short)
    self.start_at.strftime(I18n.t format, scope: [:time, :formats])
  end

  def f_end_at(format=:short)
    self.end_at.strftime(I18n.t format, scope: [:time, :formats])
  end

  def affected_users
    # retorna os usuarios afetados por essa task
    if self.calendar.present?
      [self.calendar.user]
    elsif self.account_id.present?
      Account.find(self.account_id).users
    else
      []
    end
  end

  # NOTIFICATIONS
  def create_notification
    # se o criador for diferente do usuário para qual a tarefa é direcionada
    if !self.calendar.present? or self.calendar.user != self.created_by
      # manda notificação para o usuário do calendário
      affected_users.map(&:id).each do |user_id|
        NotifyWorker.perform_async(user_id, 'Novo agendamento', "#{f_start_at} até #{f_end_at}")
      end
    end
  end

  def send_task_add_notification
    TasksWorker.perform_async(self.id)
  end

  def send_task_change_notification
    TasksWorker.perform_async(self.id, 'changed')
  end

  def send_status_changed_notification
    # enviar a notificação caso o status tenha mudado para 2 ou 3
    if !(self.status == 1 and self._id_changed?) and self.status_changed?
      send_task_change_notification
    end
  end

end
