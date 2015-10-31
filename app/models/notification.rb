class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  include Jsonable

  field :type, type: Integer
  field :title, type: String
  field :text, type: String
  field :read, type: Boolean, default: false
  field :read_at, type: Time

  belongs_to :user

  TYPES = {
    1 => "Sistema",
    2 => "E-mail"
  }

  validates_presence_of :title, :text, :user, :read
  validates :type, :inclusion => {:in => TYPES.keys, :message => 'desconhecido' }

  default_scope -> { order_by(:created_at => 'desc') }
  scope :to_user, ->(user) { where(user_id: user._id) }
  scope :sys, -> { where(type: 1) }

  scope :unreads, -> { where(read: false) }
  scope :reads, -> { where(read: true) }

  def self.to(user, title, text)
    n = new(user: user, title: title, text:text, type: 1)
    n.save!
    n
  end

  def mark_as_read
    update_attributes(read: true, read_at: Time.now)
  end

  def mark_as_unread
    update_attributes(read: false, read_at: nil)
  end

end
