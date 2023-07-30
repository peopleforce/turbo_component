TurboComponent::Engine.routes.draw do
  post "/update", to: "turbo_actions#create"
end