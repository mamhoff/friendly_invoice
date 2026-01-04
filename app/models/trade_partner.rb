class TradePartner < ApplicationRecord
  validates :name, :street, :city, :postal_code, :country_code, presence: true
  validates :country_code, length: {is: 2}

  has_many :seller_invoices, class_name: "Invoice", foreign_key: :seller_id, dependent: :restrict_with_error

  def address
    [
      legal_name, street, address_line_2, address_line_3
    ].filter_map(&:presence)
  end

  def address_line_3
    "#{postal_code} #{city}"
  end
end
