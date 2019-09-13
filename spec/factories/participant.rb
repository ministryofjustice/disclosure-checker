FactoryBot.define do
  factory :participant do
    reference { [*('A'..'Z')].sample(8).join }
    access_count { [*('0'..'9')].sample(1).join.to_i }
    opted_in { GenericYesNo::YES }

    trait :opted_out do
      opted_in { GenericYesNo::NO }
    end
  end
end
