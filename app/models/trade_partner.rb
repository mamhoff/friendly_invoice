class TradePartner < ApplicationRecord
  validates :name, :street, :city, :postal_code, :country_code, presence: true
  validates :country_code, length: {is: 2}
end
