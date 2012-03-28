FactoryGirl.define do
  factory :user do
    name     "Foo"
    email    { "#{name}@bar.com" }
    password "bazbazbaz+%"
    password_confirmation { password }
  end
end
