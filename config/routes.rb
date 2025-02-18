Rails.application.routes.draw do
  root "pages#home"

  get :upload, to: "pages#upload"
  get :review, to: "pages#review"
  get :about, to: "pages#about"
  get :overview, to: "pages#overview"

  resources :uploads, only: [:new, :create] do
    collection do
      post 'import_file'
    end
  end
end
