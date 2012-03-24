class Purchase < ActiveRecord::Base
  belongs_to :deal

  # transient attribute used to track the line number in the imported file
  # used in showing validation errors
  attr_accessor :line_num
end
