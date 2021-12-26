FactoryBot.define do
  factory :guest do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_1 { Faker::PhoneNumber.phone_number }
    phone_2 { Faker::PhoneNumber.cell_phone }
    phone_3 { Faker::PhoneNumber.cell_phone_in_e164 }
  end
end