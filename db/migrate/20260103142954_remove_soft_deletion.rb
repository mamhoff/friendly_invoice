class RemoveSoftDeletion < ActiveRecord::Migration[7.1]
  def change
    remove_column :commons, :deleted_at, :timestamp
    remove_column :items, :deleted_at, :timestamp
    remove_column :products, :deleted_at, :timestamp
    remove_column :customers, :deleted_at, :timestamp
    remove_column :series, :deleted_at, :timestamp
    remove_column :taxes, :deleted_at, :timestamp
    remove_column :templates, :deleted_at, :timestamp
    remove_column :payments, :deleted_at, :timestamp
  end
end
