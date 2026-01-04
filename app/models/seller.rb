class Seller < ApplicationRecord
  belongs_to :trade_partner

  delegate :name, to: :trade_partner
end
