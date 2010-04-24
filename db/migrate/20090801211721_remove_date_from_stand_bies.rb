class RemoveDateFromStandBies < ActiveRecord::Migration
  def self.up
    change_table :stand_bies do |t|
      t.remove :date
    end
  end

  def self.down
    change_table :stand_bies do |t|
      t.date :date
    end
  end
end
