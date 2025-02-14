Rails.application.routes.draw do
  root "pages#home"

  get :upload, to: "pages#upload"
  post :import_file, to: "pages#import_file"
  post :mapped_file, to: "pages#mapped_file"

  get :review, to: "pages#review"
  get :about, to: "pages#about"
  get :overview, to: "pages#overview"
end
