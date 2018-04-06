Rails.application.routes.draw do
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
  match 'evaluations/:id/filter' => 'evaluations#show', as: :evaluation_filter, :via => :post
  match 'evaluation_upload' => 'evaluations#upload', as: :upload_evaluation, :via => :post
  match 'evaluations/:id/nist(/category/:category)(/status/:status_symbol)' => 'evaluations#nist', as: :evaluation_nist, :via => :get

  root to: 'dashboard#index', as: :home
end
