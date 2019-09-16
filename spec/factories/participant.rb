FactoryBot.define do
  factory :participant do
    reference { [*('A'..'Z')].sample(8).join }
    access_count { [*('0'..'9')].sample(1).join.to_i }

    trait :opted_out do
      opted_out { GenericYesNo::YES }
    end

    trait :opted_in do
      opted_out { GenericYesNo::NO }
    end
  end
end
