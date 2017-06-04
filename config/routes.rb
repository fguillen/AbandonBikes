Rails.application.routes.draw do
  resources :bikes, :only => [:index, :show]
  root :to => 'bikes#home'
end