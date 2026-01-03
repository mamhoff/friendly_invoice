class CreateTradePartners < ActiveRecord::Migration[7.1]
  def change
    create_table :trade_partners do |t|
      t.string :name
      t.string :legal_name
      t.string :street
      t.string :address_line_2
      t.string :city
      t.string :postal_code
      t.string :country_code
      t.string :vat_id
      t.string :tax_id
      t.string :global_id
      t.string :global_id_scheme
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
