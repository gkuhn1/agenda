class SearchValidator
  include Mongoid::Document

  attr_accessor :start_at, :end_at, :specialty_id

  validates_presence_of :start_at, :end_at, :specialty_id

end