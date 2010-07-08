class AdminsRoles < ActiveRecord::Migration
  def self.up
    create_table :admins_roles, :force => true, :id => false do |t|
      t.integer :admin_id, :nil => false
      t.integer :role_id, :nil => false
      t.timestamps
    end
    
    add_index :admins_roles, :admin_id
    add_index :admins_roles, :role_id
  end

  def self.down
    remove_index :admins_roles, :role_id
    remove_index :admins_roles, :admin_id
    drop_table :admins_roles
  end
end
