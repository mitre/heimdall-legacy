Rails.application.routes.draw do
  resources :filter_groups do
    resources :filters, only: [:update, :destroy]
  end
  resources :filters
  resources :repos do
    resources :repo_creds, only: [:create, :update, :destroy]
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :profiles, except: [:new] do
    resources :depends, only: [:create, :destroy]
    resources :supports, only: [:create, :destroy]
    resources :controls, except: [:index]
    resources :profile_attributes, except: [:index]
    resources :groups, except: [:edit, :index]
  end
  resources :evaluations, only: [:index, :show, :destroy] do
    resources :results, only: [:index, :show]
    resources :downloads, only: [:show]
  end

  match 'profiles/:profile_id/controls/:id/details(/evaluation/:evaluation_id)' => 'controls#details', as: :profile_control_details, :via => :get
  match 'profiles/:profile_id/groups/:id/add' => 'groups#add', as: :profile_group_add, :via => :patch
  match 'profiles/:profile_id/groups/:id/remove/:control_id' => 'groups#remove', as: :profile_group_remove, :via => :patch
  match 'profiles/:id/nist(/category/:category)' => 'profiles#nist', as: :profile_nist, :via => :get
  match 'profile_upload' => 'profiles#upload', as: :upload_profile, :via => :post
  match 'evaluations/:id/ssp' => 'evaluations#ssp', as: :evaluation_ssp, :via => :get
  match 'evaluations/:id/filter' => 'evaluations#filter', as: :evaluation_filter, :via => :post
  match 'evaluations/:id/filter_select' => 'evaluations#filter_select', as: :evaluation_filter_select, :via => :post
  match 'evaluations/:id/clear_filter' => 'evaluations#clear_filter', as: :evaluation_clear_filter, :via => :get
  match 'evaluation_upload' => 'evaluations#upload', as: :upload_evaluation, :via => :post
  match 'evaluations/:id/nist(/category/:category)(/status/:status_symbol)' => 'evaluations#nist', as: :evaluation_nist, :via => :get
  match 'evaluations_compare' => 'evaluations#compare', as: :evaluations_compare, :via => [:get, :post]

  root to: 'dashboard#index', as: :home
end
