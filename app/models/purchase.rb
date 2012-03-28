class Purchase < ActiveRecord::Base
  belongs_to :deal

  # transient attributes
  attr_accessor :line_num, :allow_duplicate
  attr_accessible :purchaser_name, :quantity, :allow_duplicate

  validates_presence_of :purchaser_name, :deal_id

  validates :quantity,
    presence: true,
    numericality: { integer: 0, greater_than_or_equal_to: 0 }

  # We are going to try to prevent duplicate file uploads.
  validates :purchaser_name,
    uniqueness: {
      scope: [:quantity, :deal_id],
      message: "is duplicate (this purchase and deal already exists)",
      unless: Proc.new { |p| p.allow_duplicate.present? }
    }
end
