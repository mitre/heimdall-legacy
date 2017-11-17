Rails.application.routes.draw do
  resources :tags
  devise_for :users
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
  match 'profiles/:profile_id/controls/:id/details' => 'controls#details', :as => :profile_control_details, :via => :get
  match 'profiles/:id/nist_800_53(/category/:category)' => 'profiles#nist_800_53', :as => :profile_nist_800_53, :via => :get
  match 'profile_upload' => 'profiles#upload', :as => :upload_profile, :via => :post
  match 'evaluation_upload' => 'evaluations#upload', :as => :upload_evaluation, :via => :post
  # Root path (/)
  root :to => 'dashboard#index', :as => :home
end
