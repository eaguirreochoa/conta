Rails.application.routes.draw do
  root "welcome#index"
  
  get 'welcome/index'

  get 'rpt_bal_gral_suma_saldos/new'

  get 'rpt_estado_resuls/new'

  get 'rpt_estado_cuenta_dets/new'

  get 'rpt_diario_dets/new'

  get 'rpt_balance_grals/new'

  get 'rpt_mayors/new'

  #cuando se edita el registro de un x empleado
  get 'empleados/:id/update_povincia', to: 'empleados#update_povincia'
  get 'empleados/:id/update_localidad', to: 'empleados#update_localidad'
  #cuando se crea el registro de un x empleado
  get 'empleados/update_povincia', as: 'update_povincia'
  get 'empleados/update_localidad', as: 'update_localidad'
  get 'empleados_ajax/datatable_ajax', to: 'empleados#datatable_ajax' 

  
  get 'catalogos/listar', to: 'catalogos#listar'
  #cuando se crea una cuenta
  get 'catalogos/update_padre', as: 'update_padre'
  get 'catalogos/update_cuentasugerida', as: 'update_cuentasugerida'
  #get 'catalogos/:id/update_cuentasugerida', to: 'catalogos#update_cuentasugerida'
  #get 'catalogos/:id/update_padre', as: 'update_padre'
  #editar catalogo
  get 'catalogos/:id/edit', to: 'catalogos#edit'
  get 'catalogos/select_nodo', to: 'catalogos#select_nodo'
  get 'catalogos/imprimir', to: 'catalogos#imprimir'

  get 'diarios/listar', to: 'diarios#listar' 
  get 'diarios/update_segun_catalogo', as: 'update_segun_catalogo' 
  get 'diarios/:id/update_segun_catalogo', to: 'diarios#update_segun_catalogo'
  get 'diarios/buscar_cuenta', as: 'buscar_cuenta' 
  get 'diarios/:id/buscar_cuenta', to: 'diarios#buscar_cuenta'
  get 'diarios/update_nrocbte', as: 'update_nrocbte' 
  get 'diarios/:id/update_nrocbte', to: 'diarios#update_nrocbte'

  get '/acreedors/datatable', to: 'acreedors#datatable' 
  get '/proveedors/datatable', to: 'proveedors#datatable' 
  get '/clientes/datatable', to: 'clientes#datatable' 

  get 'rpt_estado_cuenta_dets/aux1_segun_catalogo', as: 'aux1_segun_catalogo' 

  resources :rpt_mayors , only: [:new, :create]

  resources :rpt_balance_grals, only: [:new, :create]

  resources :rpt_bal_gral_suma_saldos, only: [:new, :create]
  
  resources :rpt_diario_dets, only: [:new, :create]

  resources :rpt_estado_cuenta_dets, only: [:new, :create]  

  resources :rpt_estado_resuls, only: [:new, :create]

  get '/ajustes/datatable', to: 'ajustes#datatable' 

  get '/cierres/datatable', to: 'cierres#datatable' 

  get '/ciclos/datatable', to: 'ciclos#datatable' 

  get 'diarios/anular', to: 'diarios#anular' 

  get '/cierre_ciclos/datatable', to: 'cierre_ciclos#datatable' 


  as :user do
    get "/login" => "devise/sessions#new"
  end

  devise_for :users  
  resources :users
  resources :empleados 
  resources :catalogos
  resources :diarios
  resources :acreedors
  resources :proveedors
  resources :clientes
  resources :ajustes
  resources :cierres
  resources :cierre_ciclos
  resources :ciclos

  # do 
  #   collection do
  #     get 'update_povincia'
     
      
  #   end
  # end
  

  #root to 'users/index'
  #'devise/sessions#c' => 'users#sign_out'
  #root to: 'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
