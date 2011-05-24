Losap::Application.routes.draw do
  resources :members do
    resources :sleep_ins
    resources :standbys
  end

  match '/members/:id/:year/:month' => 'members#show', :as => :member_month
  resources :locked_months
  resource :admin_console
  resources :admins
  resources :admin_sessions
  match 'reports/:date' => 'reports#show'
  match 'login' => 'admin_sessions#new', :as => :login
  match 'logout' => 'admin_sessions#destroy', :as => :logout
  match '/' => 'members#index'
end

