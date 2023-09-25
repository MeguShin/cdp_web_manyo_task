module SessionsHelper

    # current_userの初期化
    def current_user
        # @current_userがすでに設定されていればその値を返す
        # 設定されていない場合は、データベース内にuser_idが存在するならば、user_idに一致するユーザーを検索しその値を返す
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    # 現在のユーザーオブジェクトがログインしているか確認する
    def logged_in?
        current_user.present?
    end

    def log_in(user)
        session[:user_id] = user.id
    end

    def current_user?(user)
        user == current_user
    end
end