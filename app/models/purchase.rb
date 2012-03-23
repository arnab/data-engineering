class Purchase < ActiveRecord::Base
  belongs_to :deal

  # Takes a CSV object (parsed from input file) and initializes self
  def self.parse(data)
    Purchase.new(
      purchaser_name: data['purchaser name'],
      quantity:       data['purchase count']
    )
  end
end
