class Movement < ApplicationRecord
  belongs_to :account

  validates_presence_of :amount, :reference
end
