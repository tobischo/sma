FactoryGirl.define do 
  factory :user do
    name "testmanager"
    password "secret"
    password_confirmation "secret"
    loginFails 0
  end 
end