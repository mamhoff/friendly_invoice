json.extract! trade_partner, :id, :name, :legal_name, :street, :address_line_2, :city, :postal_code, :country_code, :vat_id, :tax_id, :global_id, :global_id_scheme, :email, :phone, :created_at, :updated_at
json.url trade_partner_url(trade_partner, format: :json)
