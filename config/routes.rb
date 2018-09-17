Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :plans do
    resources :teachingfiles
  end
  root "plans#index"

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :photos, only: [:index, :create, :show, :update, :destroy]
    end
  end

  resources :materials do
    resources :teachingfiles
  end

  resources :subject_tags

  resources :lessons do
    collection do
      get :list
    end
  end

end
