class SetDraftDefaultTrue < ActiveRecord::Migration[7.1]
  def up
    change_column_default :commons, :draft, true
  end

  def down
    change_column_default :commons, :draft, false
  end
end
