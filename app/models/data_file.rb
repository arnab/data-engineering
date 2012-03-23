require 'active_model'
require 'csv'

class DataFile
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates_presence_of :data

  attr_accessor :data

  def initialize(attributes = {})
    if attributes.present?
      file = attributes[:data]
      contents = file.present? ? file.read : ""
      @data = CSV.parse(contents, col_sep: "\t", headers: :first_row, return_headers: false)
    end
  end

  def persisted?
    # DataFiles are never persisted to the DB, as is
    # @see #import
    false
  end
end
