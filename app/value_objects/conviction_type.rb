class ConvictionType < ValueObject
  include ConvictionDecorator

  attr_reader :parent, :calculator_class,
              :skip_length, :relevant_order, :no_drag_through

  alias_method :skip_length?, :skip_length
  alias_method :relevant_order?, :relevant_order
  alias_method :no_drag_through?, :no_drag_through

  def initialize(raw_value, params = {})
    @parent = params.fetch(:parent, nil)
    @calculator_class = params.fetch(:calculator_class, nil)

    # Customise journey or calculations
    @skip_length = params.fetch(:skip_length, false)
    @relevant_order = params.fetch(:relevant_order, false)
    @no_drag_through = params.fetch(:no_drag_through, false)

    super(raw_value)
  end

  VALUES = [
    YOUTH_PARENT_TYPES = [
      REFERRAL_SUPERVISION_YRO = new(:referral_supervision_yro),
      CUSTODIAL_SENTENCE       = new(:custodial_sentence),
      DISCHARGE                = new(:discharge),
      YOUTH_MOTORING           = new(:youth_motoring),
      MILITARY                 = new(:military),
      PREVENTION_REPARATION    = new(:prevention_reparation),
      FINANCIAL                = new(:financial),
    ].freeze,

    ADULT_PARENT_TYPES = [
      ADULT_COMMUNITY_REPARATION  = new(:adult_community_reparation),
      ADULT_CUSTODIAL_SENTENCE    = new(:adult_custodial_sentence),
      ADULT_DISCHARGE             = new(:adult_discharge),
      ADULT_MOTORING              = new(:adult_motoring),
      ADULT_MILITARY              = new(:adult_military),
      ADULT_FINANCIAL             = new(:adult_financial),
    ].freeze,

    #####################
    # Youth convictions #
    #####################

    REFERRAL_ORDER                     = new(:referral_order,                   parent: REFERRAL_SUPERVISION_YRO, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    SUPERVISION_ORDER                  = new(:supervision_order,                parent: REFERRAL_SUPERVISION_YRO, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    YOUTH_REHABILITATION_ORDER         = new(:youth_rehabilitation_order,       parent: REFERRAL_SUPERVISION_YRO, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    YOUTH_OTHER_REQUIREMENT_ORDER      = new(:youth_other_requirement_order,    parent: REFERRAL_SUPERVISION_YRO, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    DETENTION_TRAINING_ORDER           = new(:detention_training_order,         parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::SentenceCalculator::DetentionTraining),
    DETENTION                          = new(:detention,                        parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::SentenceCalculator::Detention),
    HOSPITAL_ORDER                     = new(:hospital_order,                   parent: CUSTODIAL_SENTENCE, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    BIND_OVER                          = new(:bind_over,                        parent: DISCHARGE, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ABSOLUTE_DISCHARGE                 = new(:absolute_discharge,               parent: DISCHARGE, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    CONDITIONAL_DISCHARGE              = new(:conditional_discharge,            parent: DISCHARGE, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    FINE                               = new(:fine,                             parent: FINANCIAL, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    COMPENSATION_TO_A_VICTIM           = new(:compensation_to_a_victim,         parent: FINANCIAL, relevant_order: true, calculator_class: Calculators::CompensationCalculator),

    DISMISSAL                          = new(:dismissal,                        parent: MILITARY, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    OVERSEAS_COMMUNITY_ORDER           = new(:overseas_community_order,         parent: MILITARY, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    SERVICE_COMMUNITY_ORDER            = new(:service_community_order,          parent: MILITARY, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    SERVICE_DETENTION                  = new(:service_detention,                parent: MILITARY, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),

    REPARATION_ORDER                   = new(:reparation_order,                 parent: PREVENTION_REPARATION, relevant_order: true, no_drag_through: true, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    RESTRAINING_ORDER                  = new(:restraining_order,                parent: PREVENTION_REPARATION, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    SEXUAL_HARM_PREVENTION_ORDER       = new(:sexual_harm_prevention_order,     parent: PREVENTION_REPARATION, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    YOUTH_DISQUALIFICATION             = new(:youth_disqualification,           parent: YOUTH_MOTORING, relevant_order: true, no_drag_through: true, calculator_class: Calculators::DisqualificationCalculator::Youths),
    YOUTH_MOTORING_FINE                = new(:youth_motoring_fine,              parent: YOUTH_MOTORING, skip_length: true, calculator_class: Calculators::Motoring::Youth::Fine),
    YOUTH_PENALTY_NOTICE               = new(:youth_penalty_notice,             parent: YOUTH_MOTORING, skip_length: true, calculator_class: Calculators::Motoring::Youth::PenaltyNotice),
    YOUTH_PENALTY_POINTS               = new(:youth_penalty_points,             parent: YOUTH_MOTORING, skip_length: true, calculator_class: Calculators::Motoring::Youth::PenaltyPoints),

    ######################
    # Adults convictions #
    ######################

    ADULT_ATTENDANCE_CENTRE_ORDER       = new(:adult_attendance_centre_order,      parent: ADULT_COMMUNITY_REPARATION, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_COMMUNITY_ORDER               = new(:adult_community_order,              parent: ADULT_COMMUNITY_REPARATION, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_CRIMINAL_BEHAVIOUR            = new(:adult_criminal_behaviour,           parent: ADULT_COMMUNITY_REPARATION, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_REPARATION_ORDER              = new(:adult_reparation_order,             parent: ADULT_COMMUNITY_REPARATION, relevant_order: true, no_drag_through: true, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    ADULT_RESTRAINING_ORDER             = new(:adult_restraining_order,            parent: ADULT_COMMUNITY_REPARATION, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_SERIOUS_CRIME_PREVENTION      = new(:adult_serious_crime_prevention,     parent: ADULT_COMMUNITY_REPARATION, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_SEXUAL_HARM_PREVENTION_ORDER  = new(:adult_sexual_harm_prevention_order, parent: ADULT_COMMUNITY_REPARATION, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_OTHER_REQUIREMENT_ORDER       = new(:adult_other_requirement_order,      parent: ADULT_COMMUNITY_REPARATION, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    ADULT_BIND_OVER                     = new(:adult_bind_over,                    parent: ADULT_DISCHARGE, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_ABSOLUTE_DISCHARGE            = new(:adult_absolute_discharge,           parent: ADULT_DISCHARGE, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    ADULT_CONDITIONAL_DISCHARGE         = new(:adult_conditional_discharge,        parent: ADULT_DISCHARGE, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    ADULT_FINE                          = new(:adult_fine,                         parent: ADULT_FINANCIAL, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusTwelveMonths),
    ADULT_COMPENSATION_TO_A_VICTIM      = new(:adult_compensation_to_a_victim,     parent: ADULT_FINANCIAL, relevant_order: true, calculator_class: Calculators::CompensationCalculator),

    ADULT_DISMISSAL                     = new(:adult_dismissal,                    parent: ADULT_MILITARY, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusTwelveMonths),
    ADULT_OVERSEAS_COMMUNITY_ORDER      = new(:adult_overseas_community_order,     parent: ADULT_MILITARY, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_SERVICE_COMMUNITY_ORDER       = new(:adult_service_community_order,      parent: ADULT_MILITARY, relevant_order: true, no_drag_through: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_SERVICE_DETENTION             = new(:adult_service_detention,            parent: ADULT_MILITARY, calculator_class: Calculators::AdditionCalculator::PlusTwelveMonths),

    ADULT_DISQUALIFICATION              = new(:adult_disqualification,             parent: ADULT_MOTORING, relevant_order: true, no_drag_through: true, calculator_class: Calculators::DisqualificationCalculator::Adults),
    ADULT_MOTORING_FINE                 = new(:adult_motoring_fine,                parent: ADULT_MOTORING, skip_length: true, calculator_class: Calculators::Motoring::Adult::Fine),
    ADULT_PENALTY_NOTICE                = new(:adult_penalty_notice,               parent: ADULT_MOTORING, skip_length: true, calculator_class: Calculators::Motoring::Adult::PenaltyNotice),
    ADULT_PENALTY_POINTS                = new(:adult_penalty_points,               parent: ADULT_MOTORING, skip_length: true, calculator_class: Calculators::Motoring::Adult::PenaltyPoints),

    ADULT_HOSPITAL_ORDER                = new(:adult_hospital_order,               parent: ADULT_CUSTODIAL_SENTENCE, relevant_order: true, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    ADULT_PRISON_SENTENCE               = new(:adult_prison_sentence,              parent: ADULT_CUSTODIAL_SENTENCE, calculator_class: Calculators::SentenceCalculator::Prison),
    ADULT_SUSPENDED_PRISON_SENTENCE     = new(:adult_suspended_prison_sentence,    parent: ADULT_CUSTODIAL_SENTENCE, calculator_class: Calculators::SentenceCalculator::SuspendedPrison),
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:

  def children
    VALUES.select { |value| value.parent.eql?(self) }
  end

  def schedule_18_applicable?
    [
      ADULT_PRISON_SENTENCE,
      DETENTION,
    ].include?(self)
  end
end
