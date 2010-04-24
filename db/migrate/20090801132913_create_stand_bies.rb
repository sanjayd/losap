class CreateStandBies < ActiveRecord::Migration
  def self.up
    create_table :stand_bies do |t|
      t.date :date
      t.time :start_time
      t.time :end_time

      t.timestamps
    end
  end

  def self.down
    drop_table :stand_bies
  end
end
