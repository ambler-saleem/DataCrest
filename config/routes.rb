Rails.application.routes.draw do
  devise_for :clients
  devise_for :agents
  devise_for :salespeople, controllers: { registrations: "salespeople/registrations",
                                          invitations: "salespeople/invitations" }
  namespace :dashboard do
    resources :salespeople_invitations, only: [:index, :create, :destroy] do
      get 'resend_invitation', on: :member
    end
    resources :application_templates
    resources :applications, only: [:edit, :update, :show]
  end
  root to: "dashboard/salespeople_invitations#index"
end
