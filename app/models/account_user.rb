class AccountUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :task_color, type: String, default: "#909090"
  field :permission, type: String, default: "owner"
  field :has_calendar, type: Mongoid::Boolean, default: true

  embedded_in :account
  belongs_to :user

  PERMISSIONS = {
    "operator" => "Operador",
    "admin" => "Administrador",
    "owner" => "Dono"
  }

  validates :permission, :inclusion => {:in => PERMISSIONS.keys, :message => 'permissão desconhecida.' }

  def permission!
    PERMISSIONS[permission]
  end

end
