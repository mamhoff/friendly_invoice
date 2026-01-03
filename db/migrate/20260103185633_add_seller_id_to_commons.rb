require "factory_bot"

class AddSellerIdToCommons < ActiveRecord::Migration[7.1]
  def up
    seller = FactoryBot.create(:trade_partner)
    add_reference :commons, :seller, null: true, foreign_key: {to_table: :commons, validate: false}
    Common.update_all(seller_id: seller.id)
    change_column_null :commons, :seller_id, false
  end

  def down
    remove_reference :commons, :seller
    TradePartner.delete_all
  end
end
