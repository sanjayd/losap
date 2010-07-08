class IndexForeignKeys < ActiveRecord::Migration
  def self.up
    add_index :sleep_ins, :member_id
    add_index :sleep_ins, :unit_type_id
    add_index :standbys, :member_id
  end

  def self.down
    remove_index :standbys, :member_id
    remove_index :sleep_ins, :unit_type_id
    remove_index :sleep_ins, :member_id
  end
end
