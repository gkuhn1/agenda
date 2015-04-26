class Specialty
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String
  field :active, type: Mongoid::Boolean, default: true
  field :deleted_at, type: Time

  belongs_to :account
  # has_and_belongs_to_many :tasks

  validates_presence_of :description, :account

  scope :not_deleted, ->{ where( :deleted_at.exists => false ) }
  scope :actives, -> { where(active: true) }

  def destroy
    self.deleted_at = Time.now
    self.save!
  end

end
