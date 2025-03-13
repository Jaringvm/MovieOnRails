Rails.application.routes.draw do
  root "pages#home"

  get :upload, to: "uploads#new"


  resources :uploads, only: [:new, :create] do
    collection do
      post 'import_file'
    end
  end
end
