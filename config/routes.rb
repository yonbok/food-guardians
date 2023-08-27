Rails.application.routes.draw do

  root 'homes#top'
  # 経営者用
  # URL /exective/sign_in ...
  devise_for :exectives, skip: [:passwords], controllers: {
  registrations: "exective/registrations",
  sessions: 'exective/sessions'
  }
  namespace :exective do
    post "items/new" => "items#new"
    resources :items, except: [:destroy]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :exectives, only: [:show, :edit, :update] do
      collection do
        get 'check_out'
        get 'withdraw'
        patch 'withdraw_update'
      end
    end
  end


  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}
  namespace :admin do
    root to: 'homes#top'
    resources :exectives, only: [:index, :show, :edit, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :items, only: [:show]
  end

  # 消費者用
  # URL /customers/sign_in ...
  devise_for :customers, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}
  scope path: 'customers', module: :public do
    resources :customers, only: [:show, :edit, :update] do
      collection do
        get 'check_out'
        get 'withdraw'
        patch 'withdraw_update'
      end
    end
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post 'confirm' #collectionがあるためorder_idがいらない
        get 'complete'
      end
    end
    resources :items, only: [:index, :show]
    resources :cart_items, only: [:index, :update, :destroy, :create] do
     collection do
        delete 'destroy_all'
     end

     resources :addresses, except: [:new, :show]
   end
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
