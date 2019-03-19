Rails.application.routes.draw do
  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :users do
      resources :accounts do
        resources :movements
      end
    end
    post '/users/:user_id/accounts/:id/transfer', to: 'accounts#transfer'
  end

  post 'auth/login', to: 'authentication#authenticate'
end
