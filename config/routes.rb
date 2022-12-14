Rails.application.routes.draw do
  # devise_for is meant to play nicely with other routes methods.
  # For example, by calling devise_for inside a namespace, it automatically nests your devise controllers.
  devise_for :users,
             # Added defaults to stop flash error
             defaults: {
               format: :json
             },
             # Usually point to devise controllers. Custom. You can remove _controller.
             controllers: {
               registrations: "users/registrations"
             }

  # Custom Auth
  post "/users/login", to: "users/authentication#login"
  post "/users/authorize", to: "users/authentication#activate_user"
  get "/users/details", to: "users/authentication#get_user_details"

  #? Token Payment Webhook
  post "/komoju/webhook", to: "token_purchase#webhook"
  post "/komoju/webhook/test", to: "token_purchase#test_webhook"

  # KOMOJU Payment
  post "/make_payment", to: "komoju/payment#make_payment"
  post "/make_payment_no_token", to: "komoju/payment#make_payment_no_token"
  get "/get_all_payments", to: "komoju/payment#get_all_user_payment_data"
  get "/get_payment_data/:id", to: "komoju/payment#get_payment_data"
  post "/cancel/:id", to: "komoju/payment#cancel_payment"

  # KOMOJU Subscriptions
  post "/subscriptions", to: "komoju/subscription#create"
  get "/subscriptions/:id", to: "komoju/subscription#get_one"
  delete "/subscriptions/:id", to: "komoju/subscription#stop" # NOT FOUND?! CHECK

  # KOMOJU Customers
  post "/customers", to: "komoju/customer#create"
  patch "/customers/:id", to: "komoju/customer#update_payment_details"
  delete "/customers/:id", to: "komoju/customer#destroy"

  # Purchase ---
  get "/purchases", to: "game_purchase#show_all"
  post "/purchases", to: "game_purchase#create"
  delete "/purchases/:id", to: "game_purchase#destroy"
  patch "/purchases/:id", to: "game_purchase#update"
  get "/purchases/aggregate/:func", to: "game_purchase#aggregate"

  # Favourites
  get "/favourites", to: "favourites#show_all"
  post "/favourites", to: "favourites#create"
  delete "/favourites/:id", to: "favourites#destroy"
  get "/favourites/aggregate/:func", to: "favourites#aggregate"

  # Cart
  get "/cart", to: "cart#show_all"
  post "/cart", to: "cart#create"
  delete "/cart/:id", to: "cart#destroy"
  get "/cart/aggregate/:func", to: "cart#aggregate"

  # Token Purchases
  get "/tokens", to: "token_purchase#show_all"
  delete "/tokens/:id", to: "token_purchase#destroy"
  get "/tokens/aggregate/:func", to: "token_purchase#aggregate"
end
