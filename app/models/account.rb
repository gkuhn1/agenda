class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :database, type: String
  field :address, type: String
  field :phone, type: String
  field :phone2, type: String
  field :website, type: String
  field :plan, type: Integer

  # has_and_belongs_to_many :users
  embeds_many :account_users
  has_many :specialties

  # before_validation :fill_out_db, if: 'name.present? and database.blank?'

  before_validation :build_user_from_attributes, if: 'user_attributes.present?'
  after_create :create_user_from_attributes

  validates_presence_of :name
  #validates_presence_of :user_ids, if: '@user_from_attributes.nil?'

  attr_accessor :user_attributes

  def build_user_from_attributes
    if user_attributes.present?
      @user_from_attributes = User.new(self.user_attributes)
      if !@user_from_attributes.valid?
        @user_from_attributes.errors.each {|k,v| self.errors.add("user_#{k}",v) }
      end
    end
  end

  def create_user_from_attributes
    if @user_from_attributes
      @user_from_attributes.save!
      self.add_user(@user_from_attributes)
    end
  end

  # def fill_out_db
  #   dc = database_candidate = self.name.parameterize
  #   count = 0
  #   while Account.where(database: database_candidate).any?
  #     count += 1
  #     database_candidate = "#{dc}_#{count}"
  #   end
  #   self.database = database_candidate
  # end

  def add_user(user)
    self.account_users.create(user: user) unless users.include?(user)
  end

  def users
    User.where(:id.in => self.account_users.map(&:user_id))
  end

  def accessible_calendar_ids
    self.users.map(&:calendar).compact.map(&:id)
  end

  def can_access_calendar?(calendar_id)
    accessible_calendar_ids.include?(calendar_id)
  end

  def get_calendar(calendar_id)
    raise Mongoid::Errors::DocumentNotFound.new(Calendar, id: calendar_id) if !can_access_calendar?(calendar_id)
    Calendar.find(calendar_id)
  end

  def calendars
    Calendar.in(id: accessible_calendar_ids)
  end

  def filter_tasks(filters)
    tasks = Task.where(account_id: self.id)
    begin
      if filters[:start_at] and filters[:end_at]
        start_at, end_at = [DateTime.parse(filters[:start_at]).utc, DateTime.parse(filters[:end_at]).utc]
        end_at += 1.day if end_at.hour == 0 and end_at.second == 0
        return tasks.where(:start_at.gt => start_at, :end_at.lt => end_at)
      end
    rescue ArgumentError => e
    end
    return tasks
  end

end
