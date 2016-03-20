FactoryGirl.define do
  factory :administrator do
    sequence(:email) { |n| "joe#{n}@example.com" }
    password         'joesthebest'
  end
end
