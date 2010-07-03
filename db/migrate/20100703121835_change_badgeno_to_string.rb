class ChangeBadgenoToString < ActiveRecord::Migration
  def self.up
    change_table :members do |t|
      t.change :badgeno, :string, :limit => 6      
    end
  end

  def self.down
    change_table :members do |t|
      t.change :badgeno, :integer      
    end
  end
end
