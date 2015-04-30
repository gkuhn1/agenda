class Notification
  include Mongoid::Document

  field :type, type: Integer
  field :read, type: Boolean, default: false
  field :read_at, type: Time
  field :text, type: String

  belongs_to :user

  TYPES = {
    1 => "Sistema",
    2 => "E-mail"
  }

  validates_presence_of :text, :user, :read
  validates :type, :inclusion => {:in => TYPES.keys, :message => 'desconhecido' }

  scope :to_user, ->(user) { where(user_id: user._id) }
  scope :sys, -> { where(type: 1) }

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def self.add(user, text)
  end

  def mark_as_read
    update_attributes(read: true, read_at: Time.now)
  end

  def mark_as_unread
    update_attributes(read: false, read_at: nil)
  end

end
