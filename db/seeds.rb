# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 一般ユーザーを作成
user = User.create!(
  name: 'user',
  email: 'user@example.com',
  password: 'password',
  admin: false
)

# 管理者ユーザーを作成
admin_user = User.create!(
  name: 'admin123',
  email: 'admin123@example.com',
  password: 'adminpassword',
  admin: true
)

# タスクデータを追加（一般ユーザーに関連付けられたタスク）
50.times do |i|
  Task.create!(
    title: "task#{i + 1}",
    content: "task#{i + 1}の説明",
    created_at: Time.current - rand(1..30).days,
    deadline_on: Time.current + rand(1..30).days,
    priority: ['低', '中', '高'].sample,
    status: ['未着手', '着手中', '完了'].sample,
    user: user
  )
end

# タスクデータを追加（管理者ユーザーに関連付けられたタスク）
50.times do |i|
  Task.create!(
    title: "admin_task#{i + 1}",
    content: "admintask#{i + 1}の説明",
    created_at: Time.current - rand(1..30).days,
    deadline_on: Time.current + rand(1..30).days,
    priority: ['低', '中', '高'].sample,
    status: ['未着手', '着手中', '完了'].sample,
    user: admin_user
  )
end