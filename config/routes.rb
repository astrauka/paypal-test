PaypalTest::Application.routes.draw do
  root to: 'pages#home'

  resource :pages, only: [] do
    get :home
    get :store_scope
    get :success
    get :error
  end

  resources :payments, only: %i(create)
end
