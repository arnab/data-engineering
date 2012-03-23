require 'active_model'
require 'csv'

class DataFile
  include ActiveModel::Conversion
  include ActiveModel::Validations

  class LineFormatValidator < ActiveModel::Validator
    def validate(record)
      return unless record.data.present?

      record.data.each_with_index do |row, i|
        line_num = i + 1 # 0-based indexes
        row.delete_if { |column_name, val| val.nil? }

        # We need 6 columns per row
        if row.size != 6
          msg = "has #{row.size} fields instead of the required 6"
          record.errors.add :base, "Line #{line_num} #{msg}: #{row.to_s}"
        end
      end
    end
  end

  validates :data, presence: true
  validates_with LineFormatValidator

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
