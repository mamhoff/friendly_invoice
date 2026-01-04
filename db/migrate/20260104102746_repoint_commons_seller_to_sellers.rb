class RepointCommonsSellerToSellers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction! # optional but safer for large tables

  def up
    remove_foreign_key :commons, :trade_parties

    execute <<~SQL
      INSERT INTO sellers (trade_party_id, created_at, updated_at)
      SELECT DISTINCT c.seller_id, NOW(), NOW()
      FROM commons c
      LEFT JOIN sellers s
        ON s.trade_party_id = c.seller_id
      WHERE s.id IS NULL
    SQL

    execute <<~SQL
      UPDATE commons c
      SET seller_id = s.id
      FROM sellers s
      WHERE s.trade_party_id = c.seller_id
    SQL

    add_foreign_key :commons, :sellers
  end

  def down
    remove_foreign_key :commons, :sellers

    execute <<~SQL
      UPDATE commons c
      SET seller_id = s.trade_party_id
      FROM sellers s
      WHERE c.seller_id = s.id
    SQL

    add_foreign_key :commons, :trade_parties
  end
end
