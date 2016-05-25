Rails.application.routes.draw do
  

  resources :articles do 
    resources :comments, only: [:create, :destroy]
    collection do
      get :feed_index, :newest_index
    end
  end
  
  devise_for :users
  
  resources :users, only: [:index, :show] do
    resource :relationships, only: [:create, :destroy]
  end
  
  root to: 'articles#index'
  
end
