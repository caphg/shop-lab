Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api, { defaults: { format: :json } } do

    post "invitations/accept", to: "invitations#accept"
    post "invitations/decline", to: "invitations#decline"
    resources :invitations, only: [:index, :create]

    resources :projects do
        resources :items
    end
  end
end
