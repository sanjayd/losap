class Admin < ActiveRecord::Base
  acts_as_authentic
  
  has_and_belongs_to_many :roles
  
  validates_uniqueness_of :username
  
  def has_role?(role_name)
    !self.roles.find_by_name(role_name).nil?
  end
end
