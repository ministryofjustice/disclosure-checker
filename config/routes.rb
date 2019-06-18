# :nocov:
def edit_step(name)
  resource name,
           only: [:edit, :update],
           controller: name,
           path_names: {edit: ''}
end
# :nocov:

# :nocov:
def show_step(name)
  resource name,
           only:       [:show],
           controller: name
end
# :nocov:

Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'

  get 'about/contact'
  get 'about/cookies'
  get 'about/privacy'
  get 'about/terms_and_conditions'

  get 'warning/reset_session'

  namespace :steps do
    namespace :check do
      edit_step :kind
      show_step :results
      show_step :exit_over18
    end

    namespace :caution do
      edit_step :is_date_known
      edit_step :known_date
      edit_step :under_age
      edit_step :caution_type
      edit_step :conditional_end_date
      edit_step :condition_complied
      show_step :condition_exit

    end

    namespace :conviction do
      edit_step :is_date_known
      edit_step :under_age
      edit_step :known_date
      edit_step :conviction_type
      edit_step :conviction_subtype
      edit_step :conviction_length
      edit_step :conviction_length_type
      edit_step :compensation_paid
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
  # :nocov:
  match '*path', to: 'errors#not_found', via: :all, constraints:
    lambda { |_request| !Rails.application.config.consider_all_requests_local }
  # :nocov:
end
