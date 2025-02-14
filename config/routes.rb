Rails.application.routes.draw do
  root "pages#home"
  get 'upload', to: 'pages#upload'
  post 'mapping', to: 'pages#mapping'
  post 'sort', to: 'pages#sort'
end
