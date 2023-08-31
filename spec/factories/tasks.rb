# 「FactoryBotを使用します」という記述
FactoryBot.define do
    # 作成するテストデータの名前を「task」とします
    # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
    factory :task do
      title { '書類作成' }
      content { '企画書を作成する。' }
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
    end
    # 作成するテストデータの名前を「second_task」とします
    # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
    factory :second_task, class: Task do
      title { 'second task' }
      content { 'second task' }
    end
  end