# Important: factories should always produce predictable data, specially dates.
# This will avoid headaches with flaky tests.
#
FactoryBot.define do
  factory :disclosure_check do
    check_group
    known_date { Date.new(2018, 10, 31) }
    under_age { GenericYesNo::YES }

    trait :youth do
      under_age { GenericYesNo::YES }
    end

    trait :adult do
      under_age { GenericYesNo::NO }
    end

    trait :caution do
      kind { CheckKind::CAUTION }
    end

    trait :conviction do
      kind { CheckKind::CONVICTION }
      conviction_date { Date.new(2018, 1, 1) }
      known_date { nil }
      caution_type { nil }
    end

    trait :with_known_date do
      known_date { Date.new(2018, 10, 31) }
    end

    trait :conviction_with_known_date do
      conviction
      with_known_date
    end

    trait :dto_conviction do
      conviction_with_known_date
      conviction_type { ConvictionType::CUSTODIAL_SENTENCE }
      conviction_subtype { ConvictionType::DETENTION_TRAINING_ORDER }
      conviction_length { 9 }
      conviction_length_type { ConvictionLengthType::WEEKS }
    end

    trait :compensation do
      conviction_with_known_date
      conviction_type { ConvictionType::FINANCIAL }
      conviction_subtype { ConvictionType::COMPENSATION_TO_A_VICTIM }
      compensation_payment_date { Date.new(2019, 10, 31) }
    end

    trait :adult_caution do
      adult
      kind { CheckKind::CAUTION }
      caution_type { CautionType::ADULT_SIMPLE_CAUTION }
    end

    trait :youth_simple_caution do
      youth
      kind { CheckKind::CAUTION }
      caution_type { CautionType::YOUTH_SIMPLE_CAUTION }
    end

    trait :youth_conditional_caution do
      youth
      kind { CheckKind::CAUTION }
      caution_type { CautionType::YOUTH_CONDITIONAL_CAUTION }
      conditional_end_date { Date.new(2018, 12, 25) }
    end

    trait :with_youth_rehabilitation_order do
      conviction_with_known_date
      youth
      conviction_type { ConvictionType::REFERRAL_SUPERVISION_YRO }
      conviction_subtype { ConvictionType::YOUTH_REHABILITATION_ORDER }
    end

    trait :with_referral_order do
      conviction_with_known_date
      youth
      conviction_type { ConvictionType::REFERRAL_SUPERVISION_YRO }
      conviction_subtype { ConvictionType::REFERRAL_ORDER }
    end

    trait :suspended_prison_sentence do
      conviction_with_known_date
      adult
      conviction_type { ConvictionType::ADULT_CUSTODIAL_SENTENCE }
      conviction_subtype { ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE }
      conviction_length_type { ConvictionLengthType::MONTHS }
      conviction_length { 15 }
    end

    # Prison

    trait :with_conviction_bail do
      conviction_bail { GenericYesNo::YES }
      conviction_bail_days { 10 }
    end

    trait :with_prison_sentence do
      adult
      conviction_with_known_date
      conviction_type { ConvictionType::ADULT_CUSTODIAL_SENTENCE }
      conviction_subtype { ConvictionType::ADULT_PRISON_SENTENCE }
      conviction_length_type { ConvictionLengthType::MONTHS }
      conviction_length { 12 }
    end

    # Financial

    trait :with_fine do
      conviction_with_known_date
      conviction_type { under_age.inquiry.yes? ? ConvictionType::FINANCIAL : ConvictionType::ADULT_FINANCIAL }
      conviction_subtype { under_age.inquiry.yes? ? ConvictionType::FINE : ConvictionType::ADULT_FINE }
    end

    # Motoring

    trait :with_motoring_disqualification do
      conviction_with_known_date
      conviction_type { under_age.inquiry.yes? ? ConvictionType::YOUTH_MOTORING : ConvictionType::ADULT_MOTORING }
      conviction_subtype { under_age.inquiry.yes? ? ConvictionType::YOUTH_DISQUALIFICATION : ConvictionType::ADULT_DISQUALIFICATION }
      conviction_length { 6 }
      conviction_length_type { ConvictionLengthType::MONTHS }
      motoring_endorsement { GenericYesNo::NO }
    end

    trait :with_motoring_penalty_points do
      conviction_with_known_date
      conviction_type { under_age.inquiry.yes? ? ConvictionType::YOUTH_MOTORING : ConvictionType::ADULT_MOTORING }
      conviction_subtype { under_age.inquiry.yes? ? ConvictionType::YOUTH_PENALTY_POINTS : ConvictionType::ADULT_PENALTY_POINTS }
      motoring_endorsement { GenericYesNo::NO }
    end

    trait :with_motoring_fine do
      conviction_with_known_date
      conviction_type { under_age.inquiry.yes? ? ConvictionType::YOUTH_MOTORING : ConvictionType::ADULT_MOTORING }
      conviction_subtype { under_age.inquiry.yes? ? ConvictionType::YOUTH_MOTORING_FINE : ConvictionType::ADULT_MOTORING_FINE }
      motoring_endorsement { GenericYesNo::NO }
    end

    # Discharge

    trait :with_bind_over do
      conviction_with_known_date
      conviction_type { under_age.inquiry.yes? ? ConvictionType::DISCHARGE : ConvictionType::ADULT_DISCHARGE }
      conviction_subtype { under_age.inquiry.yes? ? ConvictionType::BIND_OVER : ConvictionType::ADULT_BIND_OVER }
    end

    trait :with_discharge_order do
      conviction_with_known_date
      conviction_type { under_age.inquiry.yes? ? ConvictionType::DISCHARGE : ConvictionType::ADULT_DISCHARGE }
      conviction_subtype { under_age.inquiry.yes? ? ConvictionType::CONDITIONAL_DISCHARGE : ConvictionType::ADULT_CONDITIONAL_DISCHARGE }
      conviction_length { 12 }
      conviction_length_type { ConvictionLengthType::MONTHS }
    end

    # Community Reparation
    #  Only for adults

    trait :with_restraining_order do
      adult
      conviction_with_known_date
      conviction_subtype { ConvictionType::ADULT_RESTRAINING_ORDER }
      conviction_type { ConvictionType::ADULT_COMMUNITY_REPARATION }
    end

    trait :with_community_order do
      adult
      conviction_with_known_date
      conviction_type { ConvictionType::ADULT_COMMUNITY_REPARATION }
      conviction_subtype { ConvictionType::ADULT_COMMUNITY_ORDER }
      conviction_length { 12 }
      conviction_length_type { ConvictionLengthType::MONTHS }
    end

    trait :with_serious_crime_prevention do
      adult
      conviction_with_known_date
      conviction_type { ConvictionType::ADULT_COMMUNITY_REPARATION }
      conviction_subtype { ConvictionType::ADULT_SERIOUS_CRIME_PREVENTION }
    end

    trait :with_sexual_harm_order do
      adult
      conviction_with_known_date
      conviction_type { ConvictionType::ADULT_COMMUNITY_REPARATION }
      conviction_subtype { ConvictionType::ADULT_SEXUAL_HARM_PREVENTION_ORDER }
    end

    trait :completed do
      status { :completed }
    end

    trait :in_progress do
      status { :in_progress }
    end
  end
end
