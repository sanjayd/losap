class AddDeletedToSleepInAndStandby < ActiveRecord::Migration
  def self.up
    add_column :sleep_ins, :deleted, :boolean, :default => false, :null => false
    add_column :standbys, :deleted, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :sleep_ins, :deleted
  end
end
