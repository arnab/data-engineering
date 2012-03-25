class Deal < ActiveRecord::Base
  has_many :purchases

  # transient attribute used to track the line number in the imported file
  # used in showing validation errors
  attr_accessor :line_num
  attr_accessible :description, :price, :merchant_name, :merchant_address

  validates_presence_of :description, :merchant_name, :merchant_address

  validates :price,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }
end
