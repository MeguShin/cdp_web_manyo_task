# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do |i|
    Task.create!(
        title: "タスク#{i + 1}",
        content: "タスク#{i + 1}の説明",
        created_at: Time.current - rand(1..30).days,
        deadline_on: Time.current + rand(1..30).days,
        priority: ['低', '中', '高'].sample, # .sampleは'低', '中', '高'の中からランダムに選択
        status: ['未着手', '着手中', '完了'].sample
    )
end