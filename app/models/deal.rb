class Deal < ActiveRecord::Base
  has_many :purchases
end
