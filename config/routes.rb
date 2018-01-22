Rails.application.routes.draw do
  resources :tags
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :profiles do
    resources :depends
    resources :supports
    resources :controls
    resources :profile_attributes
    resources :groups
  end
  resources :evaluations do
    resources :results
  end
  match 'profiles/:profile_id/controls/:id/details(/evaluation/:evaluation_id)' => 'controls#details', :as => :profile_control_details, :via => :get
  match 'profiles/:id/nist_800_53(/category/:category)' => 'profiles#nist_800_53', :as => :profile_nist_800_53, :via => :get
  match 'profile_upload' => 'profiles#upload', :as => :upload_profile, :via => :post
  match 'evaluation_upload' => 'evaluations#upload', :as => :upload_evaluation, :via => :post
  match 'evaluations/:id/nist_800_53(/category/:category)(/status/:status_symbol)' => 'evaluations#nist_800_53', :as => :evaluation_nist_800_53, :via => :get
  # Root path (/)
  root :to => 'dashboard#index', :as => :home
end
