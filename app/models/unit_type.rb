class UnitType < ActiveRecord::Base
  def self.names
    self.all(:select => :name).collect {|u| u.name}
  end
end
