class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :firstname
      t.string :lastname
      t.integer :badgeno

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
