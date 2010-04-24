class SleepInsUseUnitTypes < ActiveRecord::Migration
  def self.up
    change_table :sleep_ins do |t|
      t.remove :unit
      t.integer :unit_type_id
    end
  end

  def self.down
    change_table :sleep_ins do |t|
      t.remove :unit_type_id
      t.string :unit
    end
  end
end
