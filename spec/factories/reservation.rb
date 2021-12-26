FactoryBot.define do
  factory :reservation do
    sequence(:reservation_code) { |n| "YYY1234567#{n}" }
    start_date { Date.today + 7.days }
    end_date { Date.today + 12.days }
    nights { 5 }
    guests { 4 }
    adults { 2 }
    children { 2 }
    infants { 0 }
    status { "accepted" }
    currency { "AUD" }
    payout_price { 4200.00 }
    security_price { 500.00 }
    total_price { 4700.00 }
    association :guest
  end
end