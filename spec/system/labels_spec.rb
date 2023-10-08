require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
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

  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        # ラベルの新規登録ページにアクセス
        visit new_label_path

        # ラベルの名前を入力
        fill_in 'label_name', with: 'サンプルラベル'

        # 登録ボタンをクリック
        click_button '登録する'

        # 登録が成功したことを検証（例: ページにラベル名が表示されること）
        expect(page).to have_content 'サンプルラベル'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        # ラベルの新規登録
        FactoryBot.create(:label, user:user)

        # ラベル一覧画面にアクセス
        visit labels_path

        # 登録済みのラベルが一覧に表示されることを検証
        expect(page).to have_content 'TestLabel01'
      end
    end
  end
end