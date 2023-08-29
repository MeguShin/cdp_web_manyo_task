# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
50.times do |i|
    Task.create!(
        title: "タスク#{i + 1}",
        description: "タスク#{i + 1}の説明",
        created_at: Time.currnet - rand(1..30).days
    )
end