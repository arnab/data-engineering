class Purchase < ActiveRecord::Base
  belongs_to :deal

  # transient attribute used to track the line number in the imported file
  # used in showing validation errors
  attr_accessor :line_num

  validates_presence_of :purchaser_name

  validates :quantity,
    presence: true,
    numericality: { integer: 0, greater_than_or_equal_to: 0 }

  # We are going to try to prevent duplicate file uploads.
  # TODO: However, this might lead to inflexibility (as there is no way for the user to upload a file)
  # even if really wants to. The way to fix that would be as follows (not implementing that as I consider)
  # this to be outside the scope of this "challenge" question:
  # 1. Introduce a "force" parameter to DataFile#create action
  # 2. Through the DataFile model, flow this transient attribute (force) into the Purchase
  # 3. Add a conditional check with a lambda to this validation, something like:
  #    :unless => { forced? }
  validates :purchaser_name,
    uniqueness: {
      scope: [:quantity, :deal_id],
      :message => "already exists (same purchase for the same deal)"
    }
end
