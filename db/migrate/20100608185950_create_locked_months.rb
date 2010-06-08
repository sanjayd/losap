class CreateLockedMonths < ActiveRecord::Migration
  def self.up
    create_table :locked_months do |t|
      t.date :month

      t.timestamps
    end
  end

  def self.down
    drop_table :locked_months
  end
end
