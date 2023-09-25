require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  # ユーザーを作成
  let(:user) { FactoryBot.create(:user) }

  describe '検索機能' do
    # テストデータを複数作成する
    let!(:first_task) { FactoryBot.create(:task31, title: "first_task_title", user: user) }
    let!(:second_task) { FactoryBot.create(:task32, title: "second_task_title", user: user) }
    let!(:third_task) { FactoryBot.create(:task33, title: "third_task_title", user: user) }

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # タイトルの検索メソッドをsearch_titleとしてscopeで定義
        # scopeを使って定義した検索メソッドに検索ワードを挿入する('first')
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq(1)
        # タイトルに"first"を含むタスクを検索
        # result = Task.title_search('first')
        # 期待される結果を検証
        # expect(result).to include(@task1) # "first_task"を含むタスク
        # expect(result).not_to include(@task2, @task3) # "first"を含まないタスク
        # あいまい検索、'first'のみで検索した結果を返す
        # result = Task.title_search('first')
        # task31に'first'が含まれているかどうか判定する
        # expect(result).to include(task31)
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_status('未着手')).to include(first_task)
        expect(Task.search_status('未着手')).not_to include(second_task)
        expect(Task.search_status('未着手')).not_to include(third_task)
        expect(Task.search_status('未着手').count).to eq(1)
      end
    end

    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        # statusはenum を使用してステータスを整数値にマッピングしている。ステータスのフィルターに渡すにはTask.statuses[]を使用
        expect(Task.search_title_and_status('first', Task.statuses['未着手'])).to include(first_task)
        expect(Task.search_title_and_status('first', Task.statuses['未着手'])).not_to include(second_task)
        expect(Task.search_title_and_status('first', Task.statuses['未着手'])).not_to include(third_task)
        expect(Task.search_title_and_status('first', Task.statuses['未着手']).count).to eq(1)
      end
    end
  end

  # Step1用
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '企画書作成', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: '企画書作成', content: '企画書を作成する。', deadline_on: '2023-09-05', priority: '低', status: '未着手', user: user)
        expect(task).to be_valid
      end
    end
  end
end