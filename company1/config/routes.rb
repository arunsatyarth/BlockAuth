Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root    'users#show'
  
	post 'signinform' => 'users#signinform'
	post 'login' => 'users#login'





  get 'user_signup'    => 'users#new'
  
  post 'user_login'    => 'users#login'
  post 'buy/:id'    => 'users#buy'

  delete 'user_logout' => 'users#destroy'

  get 'user_logout' => 'users#destroy'

      resources :users  


end
