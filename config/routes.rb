# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :warehouses do
  collection do
    post 'manage_roles'
    post 'delete_wu'
  end
  resources :inventories
end
resources :inventories
