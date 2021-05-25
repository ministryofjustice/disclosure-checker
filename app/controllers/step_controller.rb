class StepController < ApplicationController
  before_action :check_disclosure_check_presence

  before_action :check_disclosure_report_not_completed, except: [:show]

  before_action { swap_disclosure_check_session(params[:check_id]) if params[:check_id] }

  before_action :update_navigation_stack, only: [:show, :edit]

  private

  def update_and_advance(form_class, opts = {})
    hash = extract_parameters(form_class)
    record = opts[:record]

    @next_step   = params[:next_step].presence
    @form_object = form_class.new(
      hash.merge(disclosure_check: current_disclosure_check, record: record)
    )

    if @form_object.save
      destination = decision_tree_class.new(
        disclosure_check: current_disclosure_check,
        record:        record,
        step_params:   hash,
        # Used when the step name in the decision tree is not the same as the first
        # (and usually only) attribute in the form.
        as:            opts[:as],
        next_step:     @next_step
      ).destination

      redirect_to destination
    else
      render opts.fetch(:render, :edit)
    end
  end

  def extract_parameters(form_class)
    normalise_date_attributes!(
      permitted_params(form_class).to_h
    )
  end

  def permitted_params(form_class)
    params
      .fetch(form_class.model_name.singular, {})
      .permit(form_attribute_names(form_class) + additional_permitted_params)
  end

  # Some form objects might contain complex attribute structures or nested params.
  # Override in subclasses to declare any additional parameters that should be permitted.
  def additional_permitted_params
    []
  end

  def form_attribute_names(form_class)
    form_class.attribute_set.map do |attr|
      attr_name = attr.name
      primitive = attr.primitive

      primitive.eql?(Date) ? %W[#{attr_name}_dd #{attr_name}_mm #{attr_name}_yyyy] : attr_name
    end.flatten
  end

  # Converts multi-param Rails date attributes to an array that can be coerced more easily.
  # Uses the `(1i)` part to know the position in the array (index 0 being nil).
  #
  # Example: {'birth_date(1i)' => '2008', 'birth_date(2i)' => '11', 'birth_date(3i)' => '22'}
  # will be converted to an array attribute named `birth_date` with values: [nil, 2008, 11, 22]
  #
  def normalise_date_attributes!(hash)
    regex = /(?<name>.+)\((?<index>[1-3])i\)$/ # captures the attribute name and index (1 to 3)
    new_hash = {}

    hash.each do |key, value|
      next unless key =~ regex

      hash.delete(key)

      name  = Regexp.last_match(:name)
      index = Regexp.last_match(:index).to_i

      new_hash[name] ||= []
      new_hash[name][index] = value.to_i
    end.merge!(
      new_hash
    )
  end

  def update_navigation_stack
    return unless current_disclosure_check

    stack_until_current_page = if params[:check_id]
                                 # When coming from the CYA page to edit a step, we initialise the stack
                                 # with the CYA so the user can click the `back` link and return to CYA.
                                 [steps_check_check_your_answers_path]
                               else
                                 current_disclosure_check.navigation_stack.take_while { |path| path != request.path }
                               end

    current_disclosure_check.navigation_stack = stack_until_current_page + [request.path]
    current_disclosure_check.save!
  end
end
