require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    before do
      @user = User.new(
        name: 'テストユーザ',
        email: 'test@example.com',
        password: 'password',
        admin: true
      )
    end

    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        @user.name = ' '
        expect(@user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        @user.email = ' '
        expect(@user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        @user.password = ' '
        expect(@user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        @user.save
        another_user = User.new(
          name: '別のユーザ',
          email: 'test@example.com',
          password: 'password123'
        )
        expect(another_user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        @user.password = '12345'
        expect(@user).not_to be_valid
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        expect(@user).to be_valid
      end
    end
  end
end