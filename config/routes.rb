Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destory'
  
  get 'signup', to: 'users#new'
  get 'rankings/want', to: 'rankings#want'
  get 'rankings/have', to: 'rankings#have'
  resources :users, only: [:show, :new, :create]
  # 楽天 API を使った検索結果を表示するページ(new)のみを作成します。
  # 共有したいものだけを保存するため
  resources :items, only: [:show, :new]
  resources :ownerships, only: [:create, :destroy]
end
