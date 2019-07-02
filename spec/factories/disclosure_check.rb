FactoryBot.define do
  factory :disclosure_check do
    kind { CheckKind::CAUTION }
    known_date { Faker::Date.backward(14).strftime('%Y-%m-%d') }
    under_age { 'yes' }
    caution_type { CautionType::SIMPLE_CAUTION }

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

    trait :conditional_caution do
      caution_type { CautionType::CONDITIONAL_CAUTION }
      conditional_end_date { Faker::Date.backward(8).strftime('%Y-%m-%d') }
    end

    trait :youth_simple_caution do
      caution_type { CautionType::YOUTH_SIMPLE_CAUTION }
    end

    trait :youth_conditional_caution do
      caution_type { CautionType::YOUTH_CONDITIONAL_CAUTION }
    end
  end
end
