class Deal < ActiveRecord::Base
  has_many :purchases

  # transient attribute used to track the line number in the imported file
  # used in showing validation errors
  attr_accessor :line_num

  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }
end
