Lovestockholm::Application.routes.draw do
  resources :pages
  get :widget, to: 'pages#widget'
  get :map, to: 'pages#map'
  root "pages#index"

  namespace :api, defaults: {format: :json} do
    resources :results, only: [:index, :create, :update] do
      member do
        post :publish
      end
      collection do
        get :all
      end
    end
    resources :players, only: [:index, :create, :update] do
      member do
        get :show
      end
      collection do
        get :all
      end
    end
  end

  ActiveAdmin.routes(self)
end
