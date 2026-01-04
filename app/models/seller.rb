class Seller < ApplicationRecord
  belongs_to :trade_party

  delegate :name, to: :trade_party, allow_nil: true
end
