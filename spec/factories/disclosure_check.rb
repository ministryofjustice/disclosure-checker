# Important: factories should always produce predictable data, specially dates.
# This will avoid headaches with flaky tests.
#
FactoryBot.define do
  factory :disclosure_check do
    check_group
    kind { CheckKind::CAUTION }
    known_date { Date.new(2018, 10, 31) }
    under_age { GenericYesNo::YES }
    caution_type { CautionType::YOUTH_SIMPLE_CAUTION }

    trait :conviction do
      kind { CheckKind::CONVICTION }
      known_date { nil }
      under_age { nil }
      caution_type { nil }
    end

    trait :dto_conviction do
      kind { CheckKind::CONVICTION }
      conviction_type { ConvictionType::CUSTODIAL_SENTENCE }
      conviction_subtype { ConvictionType::DETENTION_TRAINING_ORDER }
      conviction_length { 9 }
      conviction_length_type { ConvictionLengthType::WEEKS }
    end

    trait :compensation do
      kind { CheckKind::CONVICTION }
      conviction_type { ConvictionType::FINANCIAL }
      conviction_subtype { ConvictionType::COMPENSATION_TO_A_VICTIM }
      compensation_payment_date { Date.new(2019, 10, 31) }
    end

    trait :youth_conditional_caution do
      caution_type { CautionType::YOUTH_CONDITIONAL_CAUTION }
      conditional_end_date { Date.new(2018, 12, 25) }
    end

    trait :suspended_prison_sentence do
      under_age { GenericYesNo::NO }
      kind { CheckKind::CONVICTION }
      conviction_type { ConvictionType::ADULT_CUSTODIAL_SENTENCE }
      conviction_subtype { ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE }
      conviction_length_type { ConvictionLengthType::MONTHS }
      conviction_length { 15 }
    end
  end
end
