class UserAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: Integer
  field :status, type: Integer
end
