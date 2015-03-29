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

  validates_presence_of :name, :description, :user_ids

  def fill_out_db
    dc = database_candidate = self.name.parameterize
    count = 0
    while Account.where(database: database_candidate).any?
      count += 1
      database_candidate = "#{dc}_#{count}"
    end
    self.database = database_candidate
  end

  def id_to_s
    self.id.to_s
  end

end
