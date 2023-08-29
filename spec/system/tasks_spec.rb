require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        # テストで使用するためのタスクを登録
        # Task.create!(title: '書類作成', content: '企画書を作成する。')
        FactoryBot.create(:task)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe '一覧表示機能' do
    # let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
    let!(:first_task) { FactoryBot.create(:task, created_at: '2025-02-18')}
    let!(:second_task) { FactoryBot.create(:task, created_at: '2025-02-17')}
    let!(:third_task) { FactoryBot.create(:task, created_at: '2025-02-16')}

    # beforeブロックを使用して、各テストケースが実行される前に共通の事前準備を行う
    before do
      # タスク一覧画面に遷移
      visit tasks_path
      # @task_list変数に全てのタスクの行を取得して格納
      @task_list = all('body tr')
    end
    # 一覧画面に遷移した場合
    context '一覧画面に遷移した場合' do
      # 作成済みタスク一覧が作成日時の降順で表示
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        expect(@task_list[1]).to have_content(first_task.title)
        expect(@task_list[2]).to have_content(second_task.title)
        expect(@task_list[3]).to have_content(third_task.title)
      end
    end
    
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        # new_task変数に現在時刻(Time.now)の新しいタスクを格納
        new_task = FactoryBot.create(:task, created_at: Time.now)
        # expectメソッドを使用して、@task_list変数に格納されたタスク一覧の行から、新しいタスクのタイトルが表示されていることを確認
        expect(@task_list[1]).to have_content(new_task.title)
      end
    end

  end
      ### Step1用 ###
      # it '作成済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを登録
        # 方法1：
        # Task.create!(title: '書類作成', content: '企画書を作成する。')
        # 方法2：
        # 下記はFactoryBotを使用して、タスクを登録
        # FactoryBot.create(:task)
        #
        # タスク一覧画面に遷移
        # visit tasks_path
        #
        # ページ遷移直後にデバッグする場合、binding.irbを使う
        # binding.irb
        #
        # visit（遷移）したpage（この場合、タスク一覧画面）に"task_title"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        # expect(page).to have_content '書類作成'
        #
        # わざと間違った結果を期待値として設定する場合
        # expect(page).to have_content '企画の予算案を作成する。'

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        # テストで使用するためのタスクを登録
        # task = Task.create!(title: '詳細表示テスト', content: '詳細表示機能をテストするためのタスク')
        # task = FactoryBot.create(:task, title: '詳細表示テスト', content: '詳細表示機能をテストするためのタスク')
        task = FactoryBot.create(:task3)
        # タスク詳細画面に遷移
        visit task_path(task)
        
        # タスクの詳細情報が画面上に表示されているかを確認
        expect(page).to have_content '詳細表示テスト'
        expect(page).to have_content '詳細表示機能をテストするためのタスク'
       end
     end
  end
end