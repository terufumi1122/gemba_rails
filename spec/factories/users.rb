FactoryBot.define do
  factory :user do
  # 上記は下記と同じ意味(userという名前から、自動でclass: Userと類推してくれている)
  # factory :admin_user, class: User do
    name     { 'テストユーザー' }
    email    { 'test1@example.com' }
    password { 'password' }
  end
end
