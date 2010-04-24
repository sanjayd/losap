class CreateUnitTypes < ActiveRecord::Migration
  def self.up
    create_table :unit_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :unit_types
  end
end
