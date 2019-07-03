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
    PARENT_TYPES = [
      ARMED_FORCES          = new(:armed_forces),
      COMMUNITY_ORDER       = new(:community_order),
      CUSTODIAL_SENTENCE    = new(:custodial_sentence),
      DISCHARGE             = new(:discharge),
      FINANCIAL             = new(:financial),
      HOSPITAL_GUARD_ORDER  = new(:hospital_guard_order),
    ].freeze,

    DISMISSAL                          = new(:dismissal,                        parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::ConvictionStartDatePlusAddedTimeCalculator),
    SERVICE_DETENTION                  = new(:service_detention,                parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::ConvictionStartDatePlusAddedTimeCalculator),
    SERVICE_COMMUNITY_ORDER            = new(:service_community_order,          parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::ConvictionStartDatePlusAddedTimeCalculator),
    OVERSEAS_COMMUNITY_ORDER           = new(:overseas_community_order,         parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::ConvictionStartDatePlusAddedTimeCalculator),

    ALCOHOL_ABSTINENCE_TREATMENT       = new(:alcohol_abstinence_treatment,     parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    ATTENDANCE_CENTRE_ORDER            = new(:attendance_centre_order,          parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    BEHAVIOURAL_CHANGE_PROG            = new(:behavioural_change_prog,          parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    CURFEW                             = new(:curfew,                           parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    DRUG_REHABILITATION                = new(:drug_rehabilitation,              parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    EXCLUSION_REQUIREMENT              = new(:exclusion_requirement,            parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    INTOXICATING_SUBSTANCE_TREATMENT   = new(:intoxicating_substance_treatment, parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    MENTAL_HEALTH_TREATMENT            = new(:mental_health_treatment,          parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    PROHIBITION                        = new(:prohibition,                      parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    REFERRAL_ORDER                     = new(:referral_order,                   parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    REHAB_ACTIVITY_REQUIREMENT         = new(:rehab_activity_requirement,       parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    REPARATION_ORDER                   = new(:reparation_order,                 parent: COMMUNITY_ORDER, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    RESIDENCE_REQUIREMENT              = new(:residence_requirement,            parent: COMMUNITY_ORDER, calculator_class: Calculators::ConvictionEndDateCalculator),
    SEXUAL_HARM_PREVENTION_ORDER       = new(:sexual_harm_prevention_order,     parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),
    SUPER_ORD_BREACH_CIVIL_INJUC       = new(:super_ord_breach_civil_injuc,     parent: COMMUNITY_ORDER, calculator_class: Calculators::ConvictionEndDateCalculator),
    UNPAID_WORK                        = new(:unpaid_work,                      parent: COMMUNITY_ORDER, calculator_class: Calculators::YouthRehabilitationOrderCalculator),

    DETENTION_TRAINING_ORDER           = new(:detention_training_order,         parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::DetentionCalculator),
    DETENTION                          = new(:detention,                        parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::DetentionCalculator),

    ABSOLUTE_DISCHARGE                 = new(:absolute_discharge,               parent: DISCHARGE, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    CONDITIONAL_DISCHARGE              = new(:conditional_discharge,            parent: DISCHARGE, calculator_class: Calculators::ConvictionEndDateCalculator),

    FINE                               = new(:fine,                             parent: FINANCIAL, skip_length: true, calculator_class: Calculators::ConvictionStartDatePlusAddedTimeCalculator),
    COMPENSATION_TO_A_VICTIM           = new(:compensation_to_a_victim,         parent: FINANCIAL, compensation: true, calculator_class: Calculators::CompensationCalculator),

    HOSPITAL_ORDER                     = new(:hospital_order,                   parent: HOSPITAL_GUARD_ORDER, calculator_class: Calculators::ConvictionEndDateCalculator),
    GUARDIANSHIP_ORDER                 = new(:guardianship_order,               parent: HOSPITAL_GUARD_ORDER, calculator_class: Calculators::ConvictionEndDateCalculator),
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
