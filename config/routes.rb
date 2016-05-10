Rails.application.routes.draw do
  
  resources :articles do 
    resources :comments, only: [:create, :destroy]
  end
  
  devise_for :users
  
  root to: 'welcome#index'
  
end
