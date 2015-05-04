class Specialty
  include Mongoid::Document
  include Mongoid::Timestamps
  # TODO use Mongoid_paranoia

  field :description, type: String
  field :active, type: Mongoid::Boolean, default: true

  field :was_deleted, type: Mongoid::Boolean, default: false
  field :deleted_at, type: Time

  belongs_to :account
  # has_and_belongs_to_many :tasks

  validates_presence_of :description, :account

  default_scope -> { order_by(:description => 'asc') }
  scope :not_deleted, ->{ where( was_deleted: false ) }
  scope :actives, -> { where(active: true) }

  def destroy
    update_attributes(was_deleted: true, deleted_at: Time.now)
  end

  # def recovery
  #   update_attributes(was_deleted: false, deleted_at: nil)
  # end

end
