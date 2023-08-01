Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount TurboComponent::Engine => "/turbo_actions"

  # Defines the root path route ("/")
  root "examples#index"
end
