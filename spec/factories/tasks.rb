FactoryBot.define do
  factory :task do
    name        { 'テストを書く' }
    description { 'RSpec&Capybara&FactoryBotを準備する' }
    user
    # 上記userは以下と同じ意味
    # association :user, factory: :admin_user
  end
end
