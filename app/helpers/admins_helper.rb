module AdminsHelper
  def role_names(admin)
    admin.roles.map do |role|
      role.name
    end.join(", ")
  end
end
