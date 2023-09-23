class SessionsController < ApplicationController
    skip_before_action :login_required, only: [:new, :create]

    # ログイン中にログイン画面またはアカウント画面にアクセスした場合、メッセージをj表示し、タスク一覧画面に遷移する
    def new
        if logged_in?
            unless current_user.admin?
                flash[:danger] = "管理者以外アクセスできません"
            else
                flash[:danger] = "ログアウトしてください"
            end
            redirect_to tasks_path
        end
    end

    def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            log_in(user)
            #redirect_to user_path(user.id)
            redirect_to tasks_path
            flash[:success] = t('sessions.new.success')
        else
            flash.now[:danger] = 'メールアドレスまたはパスワードに誤りがあります'
            render :new
        end
    end

    def destroy
        session.delete(:user_id)
        flash[:notice] = 'ログアウトしました'
        redirect_to new_session_path
    end
end
