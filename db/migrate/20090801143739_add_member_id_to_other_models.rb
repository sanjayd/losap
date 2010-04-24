class AddMemberIdToOtherModels < ActiveRecord::Migration
  def self.up
    change_table :sleep_ins do |t|
      t.integer :member_id
    end
    change_table :stand_bies do |t|
      t.integer :member_id
    end
  end

  def self.down
    change_table :sleep_ins do |t|
      t.remove :member_id
    end
    change_table :stand_bies do |t|
      t.remove :member_id
    end
  end
end
