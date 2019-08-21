class ConvictionType < ValueObject
  attr_reader :parent, :skip_length, :compensation, :calculator_class

  def initialize(raw_value, params = {})
    @parent = params.fetch(:parent, nil)
    @skip_length = params.fetch(:skip_length, false)
    @compensation = params.fetch(:compensation, false)
    @calculator_class = params.fetch(:calculator_class, nil)

    super(raw_value)
  end

  def self.find_constant(raw_value)
    const_get(raw_value.upcase)
  end

  alias skip_length? skip_length
  alias compensation? compensation

  VALUES = [
    YOUTH_PARENT_TYPES = [
      COMMUNITY_ORDER       = new(:community_order),
      CUSTODIAL_SENTENCE    = new(:custodial_sentence),
      DISCHARGE             = new(:discharge),
      FINANCIAL             = new(:financial),
      PREVENTION_REPARATION = new(:prevention_reparation),
    ].freeze,

    ADULT_PARENT_TYPES = [
      ADULT_COMMUNITY_ORDER       = new(:adult_community_order),
      ADULT_CUSTODIAL_SENTENCE    = new(:adult_custodial_sentence),
      ADULT_DISCHARGE             = new(:adult_discharge),
      ADULT_FINANCIAL             = new(:adult_financial),
      ADULT_MILITARY              = new(:adult_military),
      ADULT_MOTORING              = new(:adult_motoring),
      ADULT_PREVENTION_REPARATION = new(:adult_prevention_reparation),
    ].freeze,

    # Quick way of enabling/disabling convictions. These will not show in the interface to users.
    # If there are cucumber test, tag the affected scenarios with `@skip`.
    #
    PARENT_TYPES_DISABLED_FOR_MVP = [
      ARMED_FORCES = new(:armed_forces),
    ].freeze,

    #####################
    # Youth convictions #
    #####################
    #
    DISMISSAL                          = new(:dismissal,                        parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    SERVICE_DETENTION                  = new(:service_detention,                parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    SERVICE_COMMUNITY_ORDER            = new(:service_community_order,          parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    OVERSEAS_COMMUNITY_ORDER           = new(:overseas_community_order,         parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),

    REFERRAL_ORDER                     = new(:referral_order,                   parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    SUPERVISION_ORDER                  = new(:supervision_order,                parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    YOUTH_REHABILITATION_ORDER         = new(:youth_rehabilitation_order,       parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),

    DETENTION_TRAINING_ORDER           = new(:detention_training_order,         parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::SentenceCalculator::DetentionTraining),
    DETENTION                          = new(:detention,                        parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::SentenceCalculator::Detention),
    HOSPITAL_ORDER                     = new(:hospital_order,                   parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    BIND_OVER                          = new(:bind_over,                        parent: DISCHARGE, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ABSOLUTE_DISCHARGE                 = new(:absolute_discharge,               parent: DISCHARGE, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    CONDITIONAL_DISCHARGE              = new(:conditional_discharge,            parent: DISCHARGE, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    FINE                               = new(:fine,                             parent: FINANCIAL, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    COMPENSATION_TO_A_VICTIM           = new(:compensation_to_a_victim,         parent: FINANCIAL, compensation: true, calculator_class: Calculators::CompensationCalculator),

    REPARATION_ORDER                   = new(:reparation_order,                 parent: PREVENTION_REPARATION, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    RESTRAINING_ORDER                  = new(:restraining_order,                parent: PREVENTION_REPARATION, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    SEXUAL_HARM_PREVENTION_ORDER       = new(:sexual_harm_prevention_order,     parent: PREVENTION_REPARATION, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    ######################
    # Adults convictions #
    ######################

    ADULT_ALCOHOL_ABSTINENCE_TREATMENT  = new(:adult_alcohol_abstinence_treatment, parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_BEHAVIOURAL_CHANGE_PROG       = new(:adult_behavioural_change_prog,      parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_CURFEW                        = new(:adult_curfew,                       parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_DRUG_REHABILITATION           = new(:adult_drug_rehabilitation,          parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_ELECTRONIC_MONITORING_REQ     = new(:adult_electronic_monitoring_req,    parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_EXCLUSION_REQUIREMENT         = new(:adult_exclusion_requirement,        parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_MENTAL_HEALTH_TREATMENT       = new(:adult_mental_health_treatment,      parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_PROHIBITION                   = new(:adult_prohibition,                  parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_REHAB_ACTIVITY_REQUIREMENT    = new(:adult_rehab_activity_requirement,   parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_RESIDENCE_REQUIREMENT         = new(:adult_residence_requirement,        parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_UNPAID_WORK                   = new(:adult_unpaid_work,                  parent: ADULT_COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),

    ADULT_BIND_OVER                     = new(:adult_bind_over,                    parent: ADULT_DISCHARGE, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_ABSOLUTE_DISCHARGE            = new(:adult_absolute_discharge,           parent: ADULT_DISCHARGE, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    ADULT_CONDITIONAL_DISCHARGE         = new(:adult_conditional_discharge,        parent: ADULT_DISCHARGE, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    ADULT_FINE                          = new(:adult_fine,                         parent: ADULT_FINANCIAL, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusTwelveMonths),
    ADULT_COMPENSATION_TO_A_VICTIM      = new(:adult_compensation_to_a_victim,     parent: ADULT_FINANCIAL, compensation: true, calculator_class: Calculators::CompensationCalculator),

    ADULT_DISMISSAL                     = new(:adult_dismissal,                    parent: ADULT_MILITARY, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusTwelveMonths),
    ADULT_OVERSEAS_COMMUNITY_ORDER      = new(:adult_overseas_community_order,     parent: ADULT_MILITARY, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_SERVICE_COMMUNITY_ORDER       = new(:adult_service_community_order,      parent: ADULT_MILITARY, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_SERVICE_DETENTION             = new(:adult_service_detention,            parent: ADULT_MILITARY, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusTwelveMonths),

    ADULT_DISQUALIFICATION              = new(:adult_disqualification,             parent: ADULT_MOTORING, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_ENDORSEMENT                   = new(:adult_endorsement,                  parent: ADULT_MOTORING, skip_length: true, calculator_class: Calculators::MotoringCalculator::StartPlusFiveYears),
    ADULT_PENALTY_POINTS                = new(:adult_penalty_points,               parent: ADULT_MOTORING, skip_length: true, calculator_class: Calculators::MotoringCalculator::StartPlusThreeYears),

    ADULT_ATTENDANCE_CENTRE_ORDER       = new(:adult_attendance_centre_order,      parent: ADULT_PREVENTION_REPARATION, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),
    ADULT_REPARATION_ORDER              = new(:adult_reparation_order,             parent: ADULT_PREVENTION_REPARATION, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    ADULT_RESTRAINING_ORDER             = new(:adult_restraining_order,            parent: ADULT_PREVENTION_REPARATION, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_SEXUAL_HARM_PREVENTION_ORDER  = new(:adult_sexual_harm_prevention_order, parent: ADULT_PREVENTION_REPARATION, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_SUPERVISION_ORDER             = new(:adult_supervision_order,            parent: ADULT_PREVENTION_REPARATION, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    ADULT_HOSPITAL_ORDER                = new(:adult_hospital_order,               parent: ADULT_CUSTODIAL_SENTENCE, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_SUSPENDED_PRISON_SENTENCE     = new(:adult_suspended_prison_sentence,    parent: ADULT_CUSTODIAL_SENTENCE, calculator_class: Calculators::SentenceCalculator::SuspendedPrison),
    ADULT_PRISON_SENTENCE               = new(:adult_prison_sentence,              parent: ADULT_CUSTODIAL_SENTENCE, calculator_class: Calculators::SentenceCalculator::Prison),
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:

  def children
    VALUES.select { |value| value.parent.eql?(self) }
  end
end
