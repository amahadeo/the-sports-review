FactoryGirl.define do
  factory :user do
    username "member"
    password "123456789"
    password_confirmation "123456789"
    email "member@tsr.com"
    confirmed_at Time.now
  end
end
