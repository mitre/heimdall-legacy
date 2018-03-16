Rails.application.routes.draw do
  resources :repos do
    resources :repo_creds, only: [:create, :update, :destroy]
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :profiles do
    resources :depends, only: [:create, :destroy]
    resources :supports, only: [:create, :destroy]
    resources :controls
    resources :profile_attributes
    resources :groups
  end
  resources :evaluations do
    resources :results
    resources :downloads, only: [:show]
  end

  match 'profiles/:profile_id/controls/:id/details(/evaluation/:evaluation_id)' => 'controls#details', as: :profile_control_details, :via => :get
  match 'profiles/:profile_id/groups/:id/add' => 'groups#add', as: :profile_group_add, :via => :patch
  match 'profiles/:profile_id/groups/:id/remove/:control_id' => 'groups#remove', as: :profile_group_remove, :via => :patch
  match 'profiles/:id/nist_800_53(/category/:category)' => 'profiles#nist_800_53', as: :profile_nist_800_53, :via => :get
  match 'profile_upload' => 'profiles#upload', as: :upload_profile, :via => :post
  match 'evaluations/:id/ssp' => 'evaluations#ssp', as: :evaluation_ssp, :via => :get
  match 'evaluation_upload' => 'evaluations#upload', as: :upload_evaluation, :via => :post
  match 'evaluations/:id/nist_800_53(/category/:category)(/status/:status_symbol)' => 'evaluations#nist_800_53', as: :evaluation_nist_800_53, :via => :get

  root to: 'dashboard#index', as: :home
end
