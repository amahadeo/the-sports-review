Rails.application.routes.draw do
  
  resources :articles
  
  devise_for :users
  
  root to: 'welcome#index'
  
end
