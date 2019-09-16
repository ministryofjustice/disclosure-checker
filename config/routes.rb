def edit_step(name, &block)
  resource name,
           only: [:edit, :update],
           controller: name,
           path_names: {edit: ''} do; block.call if block_given?; end
end

def show_step(name)
  resource name,
           only:       [:show],
           controller: name
end

Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'

  get 'about/cookies'
  get 'about/privacy'
  get 'about/terms_and_conditions'

  get 'warning/reset_session'

  # Temporary routes to test adults journey
  get 'enable_adults',  controller: :experiments
  get 'disable_adults', controller: :experiments

  # Back office
  namespace :backoffice do
    resources :participants, only: [:index]
  end

  namespace :steps do
    namespace :mvp do
      edit_step :info do
        resources only: [:show, :update], controller: :info
      end
    end
    namespace :check do
      edit_step :kind
      edit_step :under_age
      show_step :exit_over18
      show_step :results
    end

    namespace :caution do
      edit_step :known_date
      edit_step :caution_type
      edit_step :conditional_end_date
    end

    namespace :conviction do
      edit_step :known_date
      edit_step :conviction_type
      edit_step :conviction_subtype
      edit_step :conviction_length
      edit_step :conviction_length_type
      edit_step :compensation_paid
      edit_step :compensation_payment_date
      show_step :compensation_not_paid
    end
  end

  resource :errors, only: [] do
    get :invalid_session
    get :unhandled
    get :not_found
    get :check_completed
  end

  # Health and ping endpoints (`status` and `health` are alias)
  defaults format: :json do
    get :status, to: 'status#index'
    get :health, to: 'status#index'
    get :ping,   to: 'status#ping'
  end

  # catch-all route
  match '*path', to: 'errors#not_found', via: :all, constraints:
    lambda { |_request| !Rails.application.config.consider_all_requests_local }
end
