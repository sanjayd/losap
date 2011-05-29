class RemoveTimestampsFromAdminsRoles < ActiveRecord::Migration
  def self.up
    remove_column :admins_roles, :created_at
    remove_column :admins_roles, :updated_at
  end

  def self.down
    add_column :admins_roles, :created_at, :datetime
    add_column :admins_roles, :updated_at, :datetime
  end
end
