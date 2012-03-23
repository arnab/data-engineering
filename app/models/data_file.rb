require 'active_model'

class DataFile
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates_presence_of :data

  attr_accessor :data

  def initialize(attributes = {})
    attributes ||= {}
    @data = attributes[:data]
  end

  def persisted?
    # DataFiles are never persisted to the DB, as is
    # @see #import
    false
  end
end
