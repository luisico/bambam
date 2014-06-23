Bambam::Application.routes.draw do
  devise_for :users, :controllers => { :invitations => 'users/invitations' }, skip: [:registrations]
  devise_scope :user do
    get 'users/sign_up' => 'users#new',                             as: 'user_sign_up'
    get 'users/cancel'  => 'users#cancel',                          as: 'user_cancel'
    get 'users/edit'    => 'devise_invitable/registrations#edit',   as: 'edit_user_registration'
    put 'users'         => 'devise_invitable/registrations#update', as: 'user_registration'
    root to: 'devise/sessions#new'
  end
  resources :users, only: [:index, :show]

  resources :tracks, except: [:new, :create]

  resources :projects

  namespace :stream_services, path: 'stream', module: false do
    resources :track, only: :show, controller: 'stream_services', format: /[^\/]+/
  end

  resources :groups, except: :index

  match 'user_root' => 'projects#index', via: [:get]
end
