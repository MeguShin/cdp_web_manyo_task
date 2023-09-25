class ApplicationController < ActionController::Base
    include SessionsHelper
    # ログインが必要なページにアクセスする前にログイン状態をチェックする
    before_action :login_required

    private

    def login_required
        unless logged_in?
            flash[:danger] = "ログインしてください"
            redirect_to new_session_path
        end
    end
end
