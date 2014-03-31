Bambam::Application.routes.draw do
  devise_for :users

  root 'pages#home'
end
