Rails.application.routes.draw do
  root "pages#home"
  get :upload, to: "pages#upload"
  get :review, to: "pages#review"
  get :about, to: "pages#about"
  get :overview, to: "pages#overview"
end
