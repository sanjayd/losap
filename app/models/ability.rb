class Ability
  include CanCan::Ability

  def initialize(admin)
    can [:read, :create], Member

    return if admin.nil?
    
    if admin.has_role?('superuser')
      can :manage, :all
    else
      can :manage, Admin, :id => admin.id
      can :read, AdminConsole
      
      if admin.has_role?('reports')
        can :read, Report
        can :manage, LockedMonth
      end
      
      if admin.has_role?('membership')
        can :manage, Member
      end
    end    
  end
end