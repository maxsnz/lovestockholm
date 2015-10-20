Lovestockholm::Application.routes.draw do
  scope "lovestockholm" do
    resources :pages
    get :widget, to: 'pages#widget'
    root "pages#index"

    namespace :api, defaults: {format: :json} do
      resources :results, only: [:index, :create, :update] do
        member do
          post :publish
        end

        collection do
          get :all
          get :winners
        end
      end
    end

    ActiveAdmin.routes(self)
  end
end
