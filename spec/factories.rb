FactoryGirl.define do
  factory :user do
    name                  "Foo"
    email                 { "#{name}@bar.com" }
    password              "bazbazbaz+%"
    password_confirmation { password }
  end

  factory :purchase do
    purchaser_name "Foo"
    quantity       1
  end

  factory :deal do
    description      "$1mm awesomeness for $10k"
    price            10_000
    merchant_name    "me me me"
    merchant_address "my place"
  end
end
