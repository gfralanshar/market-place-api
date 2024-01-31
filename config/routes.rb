Rails.application.routes.draw do
  namespace :api, default: { format: :json} do
    namespace :v1 do
      resources :users, only: [:show, :create]
    end
  end
end
