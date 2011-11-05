class AddDeletedToMember < ActiveRecord::Migration
  def change
    add_column :members, :deleted, :boolean, default: false, null: false
    add_index :members, :deleted
  end
end
