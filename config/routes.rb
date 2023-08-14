Rails.application.routes.draw do
  # 経営者用
  # URL /exective/sign_in ...
  devise_for :exectives, skip: [:passwords], controllers: {
  registrations: "exective/registrations",
  sessions: 'exective/sessions'
  }
  scope module: :exective do
    get '/' => 'homes#top'
    get  '/customers/check' => 'customers#check'
    patch  '/customers/withdraw' => 'customers#withdraw'
    resources :items, except: [:destroy]
  end


  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}
  namespace :admin do
    get '/' => 'homes#top'
    resources :items, except: [:destroy]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
  end

  # 消費者用
  # URL /customers/sign_in ...
  devise_for :customers, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}
  scope module: :public do
    root :to =>"homes#top"
    get '/about' => 'homes#about'
    get  '/customers/check' => 'customers#check'
    patch  '/customers/withdraw' => 'customers#withdraw'
    resources :items, only: [:index, :show]
  end


  # 消費者ゲストログイン用
  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  # 経営者ゲストログイン用
  devise_scope :exective do
    post 'exectives/guest_sign_in', to: 'exective/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
