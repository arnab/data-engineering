class Purchase < ActiveRecord::Base
  belongs_to :deal

  # transient attribute used to track the line number in the imported file
  # used in showing validation errors
  attr_accessor :line_num

  validates :quantity,
    presence: true,
    numericality: { integer: 0, greater_than_or_equal_to: 0 }

  validates_presence_of :purchaser_name
end
