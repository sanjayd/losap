class ChangeStandByToStandby < ActiveRecord::Migration
  def self.up
    rename_table :stand_bies, :standbys
  end

  def self.down
    rename_table :standbys, :stand_bies
  end
end
