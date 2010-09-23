class AddLastRequestAtToAdmin < ActiveRecord::Migration
  def self.up
    add_column :admins, :last_request_at, :datetime
  end

  def self.down
    remove_column :admins, :last_request_at
  end
end
