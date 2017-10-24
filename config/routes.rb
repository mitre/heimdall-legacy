Rails.application.routes.draw do
  devise_for :users
  resources :profiles do
    resources :supports
    resources :controls
    resources :profile_attributes
    resources :groups
  end
  match 'upload' => 'profiles#upload', :as => :upload_profile, :via => :post
  # Root path (/)
  root :to => 'dashboard#index'
end
