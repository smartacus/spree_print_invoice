Spree::Core::Engine.routes.append do

  namespace :admin do
    resource :invoice_settings, only: [:edit, :update]

    resources :orders do
      member do
        get :show
      end
    end
  end

end
