class CreateSleepIns < ActiveRecord::Migration
  def self.up
    create_table :sleep_ins do |t|
      t.date :date
      t.string :unit

      t.timestamps
    end
  end

  def self.down
    drop_table :sleep_ins
  end
end
