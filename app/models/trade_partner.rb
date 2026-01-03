class TradePartner < ApplicationRecord
  validates :name, :street, :city, :postal_code, :country_code, presence: true
  validates :country_code, length: {is: 2}

  has_many :seller_invoices, class_name: "Invoice", foreign_key: :seller_id, dependent: :restrict_with_error
end
