class Deal < ActiveRecord::Base
  has_many :purchases
  validates_numericality_of :price, greater_than_or_equal_to: 0.0

  # Takes a CSV object (parsed from input file) and initializes self
  def self.parse(data)
    Deal.new(
      description:      data['item description'],
      price:            data['item price'],
      merchant_name:    data['merchant name'],
      merchant_address: data['merchant address'],
    )
  end

end
