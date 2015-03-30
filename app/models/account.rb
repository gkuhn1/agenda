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

  has_and_belongs_to_many :users

  before_validation :fill_out_db, if: 'name.present?'

  validates_presence_of :name, :user_ids

  def fill_out_db
    dc = database_candidate = self.name.parameterize
    count = 0
    while Account.where(database: database_candidate).any?
      count += 1
      database_candidate = "#{dc}_#{count}"
    end
    self.database = database_candidate
  end

  def add_user(user)
    self.users << user
    user.save
    self.save
  end

end
