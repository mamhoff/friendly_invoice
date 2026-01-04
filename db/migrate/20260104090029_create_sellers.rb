class CreateSellers < ActiveRecord::Migration[7.1]
  def change
    create_table :sellers do |t|
      t.references :trade_partner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
