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

  get 'about/contact'
  get 'about/cookies'
  get 'about/privacy'
  get 'about/terms_and_conditions'
  get 'about/accessibility'

  get 'warning/reset_session'

  # Back office
  namespace :backoffice do
    get '/', to: 'home#index'
    resources :reports, only: [:index]
  end

  namespace :steps do
    resources :checks, only: [:edit, :update]

    namespace :check do
      edit_step :kind
      edit_step :under_age
      show_step :results
      show_step :check_your_answers
    end

    namespace :caution do
      edit_step :known_date
      edit_step :caution_type
      edit_step :conditional_end_date
    end

    namespace :conviction do
      edit_step :conviction_date
      edit_step :known_date
      edit_step :conviction_type
      edit_step :conviction_subtype
      edit_step :conviction_length
      edit_step :conviction_length_type
      edit_step :conviction_bail
      edit_step :conviction_bail_days
      edit_step :compensation_paid
      edit_step :compensation_payment_date
      show_step :compensation_not_paid
      edit_step :motoring_endorsement
    end
  end

  resources :checks, only: [:create], param: :group_id do
    post '', action: :create, as: :group
  end

  resources :reports, only: [] do
    put :finish
  end

  resources :results, only: [:show], param: :report_id

  resources :pilot, only: [:show]

  resource :errors, only: [] do
    get :invalid_session
    get :unhandled
    get :not_found
    get :results_not_found
    get :report_completed
    get :report_not_completed
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
