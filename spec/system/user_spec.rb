require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  # 一般ユーザーを作成
  let!(:user) { FactoryBot.create(:user) }
  # 一般ユーザー（上と別）を作成
  let!(:other_user) { FactoryBot.create(:other_user) }
  # 管理ユーザーを作成
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let!(:admin_user2) { FactoryBot.create(:admin_user2) }

  before do
    # ロングイン処理を行う
    visit '/sessions/new'

    # ラベルではなく、テキストフィールド（ページのソースを表示で分かる）のIDに合わせる
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password

    click_button 'ログイン'
  end

  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        expect(page).to have_content('タスク一覧ページ')
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do
        before do
            # ログアウト処理を行う
            click_link 'ログアウト'
        end
        it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
            # タスク一覧画面に遷移する
            visit '/tasks'        
            # 「ログインしてください」というメッセージが表示されるかを確認
            expect(page).to have_content('ログインしてください')
        end
    end
  end

  describe 'ログイン機能' do
    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        # ログイン成功のメッセージを検証
        expect(page).to have_content('ログインしました')
      end
      it '自分の詳細画面にアクセスできる' do
        click_link 'アカウント設定'
        expect(page).to have_content('アカウント詳細ページ')
      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(other_user)
        expect(page).to have_content('タスク一覧ページ')
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_content('ログアウトしました')
      end
    end
  end

  describe '管理者機能' do
    context '管理者がログインした場合' do
      before do
        # ログアウト処理を行う
        click_link 'ログアウト'
        # 管理者としてログインする
        visit '/sessions/new'

        fill_in 'session_email', with: admin_user.email
        fill_in 'session_password', with: admin_user.password

        click_button 'ログイン'
      end

      it 'ユーザ一覧画面にアクセスできる' do
        click_link 'ユーザ一覧'
        expect(page).to have_content('ユーザ一覧ページ')
      end
      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in 'user_name', with: 'admin3'
        fill_in 'user_email', with: 'admin3@example.com'
        fill_in 'user_password', with: 'password333'
        fill_in 'user_password_confirmation', with: 'password333'
        check 'user_admin'
        click_button '登録する'
        expect(page).to have_content('ユーザ一覧ページ')
        expect(page).to have_content('admin3')
      end
      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(admin_user)
        expect(page).to have_content('ユーザ詳細ページ')
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(other_user)
        fill_in 'user_name', with: 'ohter user2'
        fill_in 'user_email', with: 'otheruser2@example.com'
        fill_in 'user_password', with: 'passwordotheruser'
        fill_in 'user_password_confirmation', with: 'passwordotheruser'
        check 'user_admin'
        click_button '更新する'
        expect(page).to have_content('タスク一覧ページ')
      end
      it 'ユーザを削除できる' do
        click_link 'ユーザ一覧'
        # other_userの削除リンクをクリック
        click_link '削除', href: user_path(other_user)
        # 削除確認のポップアップが表示されるかどうか確認
        page.driver.browser.switch_to.alert.accept
        # 削除成功のメッセージが表示されることを確認
        expect(page).to have_content('ユーザを削除しました')
        # ユーザ一覧ページに削除したユーザーが表示されないことを確認
        expect(page).not_to have_content(other_user.name)
        expect(page).to have_content('ユーザ一覧ページ')
      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        # ログアウト処理を行う
        click_link 'ログアウト'
        # 管理者としてログインする
        visit '/sessions/new'

        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password

        click_button 'ログイン'
      end

      it 'ユーザ一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        click_link 'ユーザ一覧'
        expect(page).to have_content('管理者以外アクセスできません')
      end
    end
  end
end