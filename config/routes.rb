TheGarageSale::Application.routes.draw do

  get "pages/about_us"
  get "pages/terms_of_use"
  get "pages/privacy_policy"

  resources :sales do
    resources :featured_items do
      member do
        post 'bid'
        get 'sell'
        get 'deactivate'
      end    
    end  
    
    resources :comments
    collection do
      post 'load_city'
      post 'load_neighborhoods'
      post 'post_sale'
      post 'plan_sale'
      get 'plan_route'
      get 'search'
      post 'search'
      get 'my_fav_sales'
      get 'my_sales'
      get 'email_list'
      
    end
    member do
      get 'add_to_favorite'
      get 'get_directions'
      get 'sale_stats'
      get 'remove_favorite'
      get 'payment_details'
      get 'sale_payment_details'
      post 'money_transaction'
      post 'sale_money_transaction'
      get 'deactivate'
    end
  end
  resources :shipping_terms
  
  resources :featured_items do
    collection do 
      get 'bidding_items'
      get 'my_purchase_list'
    end  
  end
  
  resources :neighborhoods
  resources :cities do
    member do
      get 'deactivate'
    end  
  end
  resources :states do
   member do
      get 'deactivate'
    end
  end  
  resources :messages, :only=>[:new,:show,:index,:create]
  resources :categories do
    member do
      get 'deactivate'
    end  
  end  
  resources :users do
    member do
      put 'change_user_password'
    end  
    collection do
      get 'account_activate'
    end
  end

  resources :forgot_password,:only=>[:create, :new] do
    collection do
      get 'change_password'
      post 'update_password'
    end
  end

  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'sign_up'=>'users#new',:as=>:sign_up
  match 'sessions/create' => 'sessions#create'
  match 'home' => 'users#home', :as => :home
  match 'terms_of_user' => "pages#terms_of_use" , :as => :terms_of_use
  match 'privacy_policy' => "pages#privacy_policy" , :as => :privacy_policy
  match 'analytics_report' => "pages#analytics_report" , :as => :analytics_report
  
  root :to => "users#home"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

