json.extract! trade_party, :id, :name, :legal_name, :street, :address_line_2, :city, :postal_code, :country_code, :vat_id, :tax_id, :global_id, :global_id_scheme, :email, :phone, :created_at, :updated_at
json.url trade_party_url(trade_party, format: :json)
