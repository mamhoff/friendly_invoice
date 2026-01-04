class Seller < ApplicationRecord
  belongs_to :trade_party

  delegate :name,
    :address,
    :street,
    :address_line_2,
    :address_line_3,
    :legal_name,
    to: :trade_party
end
