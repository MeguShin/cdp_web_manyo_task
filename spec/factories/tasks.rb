FactoryBot.define do
  # Step3用データ
  factory :task31, class: Task do
    title { 'first_task' }
    content { 'first_task' }
    deadline_on { '2025-02-18'}
    priority { '中' }
    status { '未着手' }
  end
  factory :task32, class: Task do
    title { 'second_task' }
    content { 'second_task' }
    deadline_on { '2025-02-17'}
    priority { '高' }
    status { '着手中' }
  end
  factory :task33, class: Task do
    title { 'third_task' }
    content { 'third_task' }
    deadline_on { '2025-02-16'}
    priority { '低' }
    status { '完了' }
  end

  # Step1用
  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
  # Step3から、deadline_on以降追加
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on { '2026-02-18'}
    priority { '中' }
    status { '未着手' }
  end
  factory :task1, class: Task do
    title { '書類作成'}
    content { '企画書を作成する。'}
  end
  factory :task2, class: Task do
    title { 'データ整理'}
    content { 'データを整理する'}
  end
  factory :task3, class: Task do
    title { '詳細表示テスト'}
    content { '詳細表示機能をテストするためのタスク'}
    deadline_on { '2026-02-18'}
    priority { '中' }
    status { '未着手' }
  end
  # Step1用
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task, class: Task do
    title { 'second task' }
    content { 'second task' }
  end
end
