Bambam::Application.routes.draw do
  devise_for :users, :controllers => { :invitations => 'users/invitations' }, skip: [:registrations]
  devise_scope :user do
    get 'users/sign_up' => 'users#new',                             as: 'user_sign_up'
    get 'users/cancel'  => 'users#cancel',                          as: 'user_cancel'
    get 'users/edit'    => 'devise_invitable/registrations#edit',   as: 'edit_user_registration'
    put 'users'         => 'devise_invitable/registrations#update', as: 'user_registration'
    root to: 'devise/sessions#new'
  end
  resources :users, only: [:index]

  resources :tracks

  get 'stream/:filename', to: 'stream_services#stream', as: 'stream', filename: /.+/

  match 'user_root' => 'tracks#index', via: [:get]
end
