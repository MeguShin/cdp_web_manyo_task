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
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを登録
        # Task.create!(title: '書類作成', content: '企画書を作成する。')
        FactoryBot.create(:task)
        # タスク一覧画面に遷移
        visit tasks_path
        # ページ遷移直後にデバッグ
        #binding.irb
        # visit（遷移）したpage（この場合、タスク一覧画面）に"task_title"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        # わざと間違った結果を期待値として設定
        # expect(page).to have_content '企画の予算案を作成する。'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        # テストで使用するためのタスクを登録
        # task = Task.create!(title: '詳細表示テスト', content: '詳細表示機能をテストするためのタスク')
        # task = FactoryBot.create(:task, title: '詳細表示テスト', content: '詳細表示機能をテストするためのタスク')
        task = FactoryBot.create(:task1)
        # タスク詳細画面に遷移
        visit task_path(task)
        
        # タスクの詳細情報が画面上に表示されているかを確認
        expect(page).to have_content '詳細表示テスト'
        expect(page).to have_content '詳細表示機能をテストするためのタスク'
       end
     end
  end
end