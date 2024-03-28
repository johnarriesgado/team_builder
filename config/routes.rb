Rails.application.routes.draw do
  namespace :api do
    resources :players
    post 'team/process', to: 'teams#process_team'
  end

  # Default route for handling routing errors
  match '*unmatched_route', to: 'application#route_not_found', via: :all
end