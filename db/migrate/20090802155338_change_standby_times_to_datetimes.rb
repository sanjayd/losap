class ChangeStandbyTimesToDatetimes < ActiveRecord::Migration
  def self.up
    change_column :stand_bies, :start_time, :datetime
    change_column :stand_bies, :end_time, :datetime
  end

  def self.down
    change_table :stand_bies, :start_time, :time
    change_table :stand_bies, :end_time, :time
  end
end
