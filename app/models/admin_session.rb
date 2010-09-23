class AdminSession < Authlogic::Session::Base
  logout_on_timeout true
end