class Ability
  include CanCan::Ability

  def initialize(admin)
    if admin.nil?
      can :read, Member
      return
    end
    
    can :manage, :all if admin.has_role?('superuser')
    
    if admin.has_role?('reports')
      can :read, AdminConsole
      can :read, Report
      can :manage, LockedMonth
      can :manage, Admin, :id => admin.id
    end
    
    if admin.has_role?('membership')
      can :read, AdminConsole
      can :manage, Member
      can :manage, Admin, :id => admin.id
    end    
  end
end