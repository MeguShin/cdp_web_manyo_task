class Admin::UsersController < ApplicationController
    before_action :require_admin

    def index
        # 全てのuser情報を@usersに入力
        @users = User.includes(:tasks).all
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            log_in(@user)
            redirect_to admin_users_path
        else
            render :new
        end
    end

    def show
        #@users = User.find(params[:id])
        @user = User.includes(:tasks).find(params[:id])
        @tasks = @user.tasks
    end
    
    # ユーザー情報の編集フォームを表示。updateに情報を送信。
    def edit
        @user = User.find(params[:id])
    end

    # ユーザー情報の更新
    # def update
    #     @user = User.find(params[:id])
    #     # ユーザーが送信したフォームデータを使用し、ユーザーの情報を更新。更新が成功（バリデーションなどのエラーがない場合）した場合、条件が真
    #     if @user.update(user_params)
    #         unless current_user.admin?
    #             redirect_to user_path(@user)
    #             flash[:success] = t('users.edit.success')
    #         else
    #             if current_user.admin? && User.where(admin: true).count <= 1
    #                 flash[:error] = "管理者が0人になるため、権限を変更できません。"
    #                 redirect_to admin_users_path
    #             else
    #                 redirect_to admin_users_path
    #                 flash[:success] = t('users.edit.success')
    #             end
    #         end
    #     else
    #         render :edit
    #     end
    # end
    def update
        @user = User.find(params[:id])
        # ユーザーが送信したフォームデータを使用し、ユーザーの情報を更新。更新が成功（バリデーションなどのエラーがない場合）した場合、条件が真
        if @user.update(user_params)
            redirect_to admin_users_path
            flash[:success] = t('users.edit.success')
        else
            render :edit
        end
    end

    # ユーザー情報の削除
    def destroy
        if current_user.admin? && User.where(admin: true).count <= 1
            flash[:error] = "管理者が0人になるため削除できません"
            redirect_to admin_users_path
        else
            @user = User.find(params[:id])
            @user.destroy
            flash[:success] = "ユーザを削除しました"
            redirect_to admin_users_path
        end
    end
    # def destroy
    #     @user = User.find(params[:id])
    #     @user.destroy
    #     redirect_to admin_users_path
    # end
    
    private

    def require_admin
        unless current_user.admin?
            flash[:error] = "管理者以外アクセスできません"
            redirect_to new_session_path
        end
    end

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to current_user unless current_user?(@user)
    end

    # # 管理者削除に関する処理
    # def check_last_admin
    #     if self.admin? && User.where(admin: true).count <= 1
    #         errors.add(:base, "管理者が0人になるため削除できません")
    #         throw(:abort)
    #     end
    # end
end
