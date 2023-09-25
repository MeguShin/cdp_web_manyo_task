require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  # 一般ユーザーを作成
  let!(:user) { FactoryBot.create(:user) }
  # 管理ユーザーを作成
  #let!(:admin_user) { FactoryBot.create(:admin_user) }
  
  before do
    # ロングイン処理を行う
    visit '/sessions/new'

    # ラベルではなく、テキストフィールド側（session）のIDに合わせる
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password

    click_button 'ログイン'
  end

  # Step2で作成
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        # テストで使用するためのタスクを登録
        # Task.create!(title: '書類作成', content: '企画書を作成する。')
        FactoryBot.create(:task, user: user)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列がhave_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end
  # Step2で作成
  describe '一覧表示機能' do
    # Step2から作成
    # let!を使ってテストデータを変数として定義することで、複数のテストでテストデータを共有できる
    let!(:first_task) { FactoryBot.create(:task, created_at: '2025-02-18', user: user)}
    let!(:second_task) { FactoryBot.create(:task, created_at: '2025-02-17', user: user)}
    let!(:third_task) { FactoryBot.create(:task, created_at: '2025-02-16', user: user)}
    # Step3用
    # テストデータを複数作成する
    let!(:first_task3) { FactoryBot.create(:task31, title: 'first_task', user: user) }
    let!(:second_task3) { FactoryBot.create(:task32, title: "second_task", user: user) }
    let!(:third_task3) { FactoryBot.create(:task33, title: "third_task", user: user) }
    # beforeブロックを使用して、各テストケースが実行される前に共通の事前準備を行う
    before do
      # タスク一覧画面に遷移
      visit tasks_path
      # @task_list変数に全てのタスクの行を取得して格納
      @task_list = all('body tr')
    end
    # Step2で作成
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
        new_task = FactoryBot.create(:task, created_at: Time.now, user: user)
        # expectメソッドを使用して、@task_list変数に格納されたタスク一覧の行から、新しいタスクのタイトルが表示されていることを確認
        expect(@task_list[1]).to have_content(new_task.title)
      end
    end
    # Step3で作成
    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          # タスク一覧ページにアクセス
          visit tasks_path
          # "deadline_on"リンクをクリックしてソートする
          click_link Task.human_attribute_name(:deadline_on)
          # 最初のタスクのdeadline_onが古い順かどうかを確認する
          # tr:nth-child(1)は1行目、td:nth-child(4)は4列目を指す=>deadline_onの値する位置
          first_task_deadline = find('table tr:nth-child(1) td:nth-child(4)').text
          second_task_deadline = find('table tr:nth-child(2) td:nth-child(4)').text
          # 1行目のdeadline_onよりも2行目のdeadline_onの方が古い順であることを確認
          expect(first_task_deadline).to be <= second_task_deadline
        end
      end
      context '「優先度」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # タスク一覧ページにアクセス
          visit tasks_path
          click_link Task.human_attribute_name(:priority)
          first_priority = find('table tr:nth-child(2) td:nth-child(5)').text
          second_priority = find('table tr:nth-child(3) td:nth-child(5)').text
          expect(first_priority).to be >= second_priority
        end
      end
    end
    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it "検索ワードを含むタスクのみ表示される" do
          # タスク一覧画面にアクセス
          visit tasks_path
          # 検索フォーム(title)に「first」と入力し、検索ボタンをクリック
          fill_in 'title', with: 'first'
          click_button '検索'          
          # 期待する結果を確認(タイトルに'first'とついたタスク(first_task)のみ表示)
          expect(page).to have_content 'first'
          expect(page).not_to have_content 'second'
          expect(page).not_to have_content 'third'
        end
      end
      context 'ステータスで検索した場合' do
        it "検索したステータスに一致するタスクのみ表示される" do
          # タスク一覧画面にアクセス
          visit tasks_path
          # ステータスのセレクトボックスから「着手中」を選択
          select '着手中', from: 'status'
          # 検索ボタンをクリック
          click_button '検索'
          # 期待する結果を確認(「着手中」のステータスをもつタスクは「second_task」のみであることを確認)
          expect(page).to have_content 'second_task'
          expect(page).not_to have_content 'first_task'
          expect(page).not_to have_content 'third_task'
        end
      end
      context 'タイトルとステータスで検索した場合' do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          # タスク一覧画面にアクセス
          visit tasks_path
          # 検索フォーム(title)に「first」と入力
          fill_in 'title', with: 'first'
          # ステータスのセレクトボックスから「未着手」を選択
          select '未着手', from: 'status'
          # 検索ボタンをクリック
          click_button '検索'
          # 期待する結果を確認(タイトルに'first'、ステータスが「未着手」のタスク(first_task)のみ表示)
          expect(page).to have_content 'first'
          expect(page).not_to have_content 'second'
          expect(page).not_to have_content 'third'
        end
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
  # Step1で作成
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        # テストで使用するためのタスクを登録
        # task = Task.create!(title: '詳細表示テスト', content: '詳細表示機能をテストするためのタスク')
        # task = FactoryBot.create(:task, title: '詳細表示テスト', content: '詳細表示機能をテストするためのタスク')
        task = FactoryBot.create(:task3, user: user)
        # タスク詳細画面に遷移
        visit task_path(task)
        # タスクの詳細情報が画面上に表示されているかを確認
        expect(page).to have_content '詳細表示テスト'
        expect(page).to have_content '詳細表示機能をテストするためのタスク'
       end
     end
  end
end