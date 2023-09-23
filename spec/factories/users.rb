FactoryBot.define do
  factory :user, class: User do
    name { "John Doe" } # 例: ユーザー名を指定
    email { "john@example.com" } # 例: メールアドレスを指定
    password { "password123" } # 例: パスワードを指定
    admin { false } # 例: 管理者権限を指定
  end

  factory :other_user, class: User do
    name { "ohter user" } # 例: ユーザー名を指定
    email { "otheruser@example.com" } # 例: メールアドレスを指定
    password { "password456" } # 例: パスワードを指定
    admin { false } # 例: 管理者権限を指定
  end

  factory :admin_user, class: User do
    name { "admin" } # 例: ユーザー名を指定
    email { "admin@example.com" } # 例: メールアドレスを指定
    password { "adminpassword" } # 例: パスワードを指定
    admin { true } # 例: 管理者権限を指定
  end

  factory :admin_user2, class: User do
    name { "admin2" } # 例: ユーザー名を指定
    email { "admin2@example.com" } # 例: メールアドレスを指定
    password { "admin2password" } # 例: パスワードを指定
    admin { true } # 例: 管理者権限を指定
  end
end
