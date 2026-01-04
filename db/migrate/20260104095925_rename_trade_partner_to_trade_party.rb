class RenameTradePartnerToTradeParty < ActiveRecord::Migration[7.1]
  def change
    rename_table :trade_partners, :trade_parties
    rename_column :sellers, :trade_partner_id, :trade_party_id
  end
end
