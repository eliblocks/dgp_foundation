Rails.application.routes.draw do

  root 'causes#index'
  resources :causes do
    resources :donations, shallow: true
  end
  get '/payment_confirmation', to: 'donations#confirmation'
end
