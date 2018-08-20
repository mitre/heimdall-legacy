Rails.application.routes.draw do
  resources :users do
    get :image, on: :member
  end
  resources :circles
  resources :filter_groups do
    resources :filters, only: [:update, :destroy]
  end
  resources :filters
  resources :repos do
    resources :repo_creds, only: [:create, :update, :destroy]
  end
  devise_for :db_users, controllers: {
    sessions: 'db_users/sessions',
    registrations: 'db_users/registrations',
    passwords: 'db_users/passwords'
  }
  devise_for :ldap_users, controllers: {
    sessions: 'ldap_users/sessions',
    registrations: 'ldap_users/registrations',
    passwords: 'ldap_users/passwords'
  }
  resources :profiles, except: [:new] do
    resources :depends, only: [:create, :destroy]
    resources :supports, only: [:create, :destroy]
    resources :controls, except: [:index]
    resources :profile_attributes, except: [:index]
    resources :groups, except: [:edit, :index]
    post 'upload', on: :collection
  end
  resources :evaluations, only: [:index, :show, :destroy] do
    resources :results, only: [:index, :show]
    resources :downloads, only: [:show]
    get 'ssp', on: :member
    post 'filter', on: :member
    post 'filter_select', on: :member
    get 'clear_filter', on: :member
    post 'upload', on: :collection
    post 'upload_api', on: :collection
  end

  match 'session/new_session' => 'users#new_session', as: :new_user_session, :via => :get
  match 'circles/:id/members' => 'circles#members', as: :circle_members, :via => :post
  match 'circles/:id/remove_member/:user_id' => 'circles#remove_member', as: :circle_member_remove, :via => :delete
  match 'circles/:id/owners' => 'circles#owners', as: :circle_owners, :via => :post
  match 'circles/:id/remove_owner/:user_id' => 'circles#remove_owner', as: :circle_owner_remove, :via => :delete
  match 'circles/:id/evals' => 'circles#evaluations', as: :circle_evals, :via => :post
  match 'circles/:id/remove_eval/:evaluation_id' => 'circles#remove_evaluation', as: :circle_eval_remove, :via => :delete
  match 'circles/:id/profiles' => 'circles#profiles', as: :circle_profiles, :via => :post
  match 'circles/:id/remove_profile/:profile_id' => 'circles#remove_profile', as: :circle_profile_remove, :via => :delete
  match 'profiles/:profile_id/controls/:id/details(/evaluation/:evaluation_id)' => 'controls#details', as: :profile_control_details, :via => :get
  match 'profiles/:profile_id/groups/:id/add' => 'groups#add', as: :profile_group_add, :via => :patch
  match 'profiles/:profile_id/groups/:id/remove/:control_id' => 'groups#remove', as: :profile_group_remove, :via => :patch
  match 'profiles/:id/nist(/category/:category)' => 'profiles#nist', as: :profile_nist, :via => :get
  match 'evaluation_upload_api' => 'evaluations#upload_api', as: :upload_evaluation_api, :via => :post
  match 'evaluations/:id/nist(/category/:category)(/status/:status_symbol)' => 'evaluations#nist', as: :evaluation_nist, :via => :get
  match 'evaluations/:id/xccdf' => 'evaluations#xccdf', as: :evaluation_xccdf, :via => :get
  match 'evaluations/:id/xccdf' => 'evaluations#create_xccdf', as: :evaluation_create_xccdf, :via => :post
  match 'evaluations_compare' => 'evaluations#compare', as: :evaluations_compare, :via => [:get, :post]
  match 'users/:id/add_role/:user_id/' => 'users#add_role', as: :user_add_role, :via => :post
  match 'users/:id/remove_role/:user_id/:role' => 'users#remove_role', as: :user_remove_role, :via => :delete

  root to: 'dashboard#index'
end
