Rails.application.routes.draw do

  # We are adding full resources for bird and declaring which controller to use
  resources :birds, :controller => 'ruby_static/birds'

  # If you had nests and wanted to nest your nests you would do:

  # It's that simple.  Run rake routes from your 'main app' and you will see
  # the routes from the engine listed after any routes you define in the main
  # app.

  root :to => "ruby_static/birds#index"
  
end