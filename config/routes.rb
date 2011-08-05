Kato::Application.routes.draw do
  # ActiveAdmin.routes(self)

  # devise_for :admin_users, ActiveAdmin::Devise.config

  resources :votes

  resources :categories

  resources :messages do
    collection do
      get 'add'
      post 'verify'
    end
    member do
      get 'publish'
    end
  end

  devise_for :users do
    post 'users/fb_auth(.:format)' => "devise/facebook_consumer#auth"
    post 'users/fb_callback(.:format)' => "devise/facebook_consumer#callback"
  end

  resource :users do
    post 'users/fb_auth(.:format)' => "devise/facebook_consumer#auth"
    post 'users/fb_callback(.:format)' => "devise/facebook_consumer#callback"
  end
  match "/terms" => "home#terms", :as => "terms"
  match "/terminos_y_condiciones" => "home#terms", :as => "terms", :via => "post"
  match "/recetas/:id", :to => "messages#show", :via => "post"
  match "/recetas/:id", :to => "messages#show", :via => "get", :as => :facebook_recipe
  match "/recetas", :to => "messages#index", :via => "get", :as => :facebook_recipes
  match "/recetas", :to => "messages#index", :via => "post"
  match "/nueva_receta", :to => "messages#add", :via => ["post", "get"], :as => :add_recipes
  root :to => "home#index"
end
