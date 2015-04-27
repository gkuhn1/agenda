class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic

  is_gravtastic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :name,               type: String, default: ""
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  ## Custom fields
  field :admin,             type: Boolean, default: false
  field :token,             type: String

  attr_accessor :generate_password

  has_one :calendar

  before_validation :generate_password!
  before_validation :generate_token!
  validates_presence_of :name, :token

  after_create :create_calendar!
  before_destroy :destroy_calendar!

  def create_calendar!
    Calendar.create(user: self) if self.calendar.nil?
  end

  def destroy_calendar!
    self.calendar.destroy if self.calendar.present?
  end

  def generate_token!
    self.token = Devise.friendly_token if self.token.blank?
  end

  def generate_password!
    self.password = Devise.friendly_token.first(8) if self.generate_password and self.encrypted_password.blank?
  end

  def admin?
    self.admin == true
  end

  def accounts
    Account.where({'account_users' => {'$elemMatch': {"user_id": _id}}})
  end

  def account_user_for(account)
    accounts.find(account._id).account_users.where({"user_id": _id}).first if account
  end
end
