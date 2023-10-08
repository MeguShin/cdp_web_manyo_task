class TasksController < ApplicationController
    before_action :set_task, only: %i[ show edit update destroy ]
    before_action :login_required
  
    # ログインしているユーザーのタスクだけを表示する
    def index
      @tasks = current_user.tasks.filtered_tasks(params).page(params[:page]).per(10)
      @labels = Label.all

      if params[:label_ids].present?
        label_ids = params[:label_ids].map(&:to_i)
        @tasks = @tasks.joins(:labels).where(labels: { id: label_ids })
      end
      #@tasks = Task.filtered_tasks(params).page(params[:page]).per(10)
      #以下内容は、「app/models/tasks.rb」に移動
      # case params[:order]
      #   # 「終了期限」を昇順に並び替え
      #   when 'deadline_on'
      #     @tasks = Task.order(deadline_on: :asc).page(params[:page]).per(10)
      #   # 「優先度」を降順に並び替え
      #   when 'priority'
      #     @tasks = Task.order(priority: :desc).page(params[:page]).per(10)
      #   # 上記以外
      #   else
      #     @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
      #   end
  
      #   # "title"パラメータに値があれば、その値でタイトルでフィルタリング
      #   if params[:title].present?
      #     @tasks = @tasks.where("title LIKE ?", "%#{title}%")
      #     #@tasks = @tasks.title_search(params[:title])
      #   end
        
      #   # "status"パラメータに値があれば、その値でフィルタリング
      #   if params[:status].present?
      #     @tasks = @tasks.where(status: params[:status])
      #   end
  
      #   @tasks = @tasks.page(params[:page]).per(10)
    end
  
    def new
      @task = Task.new
    end
  
    def create
      # ログインしているユーザーの情報を保存することで、ユーザーとタスクを関連付ける
      #@task = Task.new(task_params)
      @task = current_user.tasks.build(task_params)

      # "current_user.tasks.build"を使用して、ログインしているユーザーに関連付けられた新しいタスクを作成する
      if @task.save
        redirect_to tasks_path, notice: t('.created')
      else
        render :new
      end
    end
  
    def show
      @task = Task.find(params[:id])
      @labels = @task.labels
    end
  
    def edit
    end
  
    def update
      if @task.update(task_params)
        redirect_to tasks_path, notice: t('.updated')
      else
        render :edit
      end
    end
  
    def destroy
      @task.destroy
      redirect_to tasks_path, notice: t('.destroyed')
    end
  
    private
      # 他人のタスクにアクセスしようとした場合にメッセージを表示し、タスク一覧画面に遷移する
      def set_task
        @task = Task.find(params[:id])
        # 該当のタスクのユーザーと現在のユーザーを比較する
        unless @task.user == current_user
          flash[:danger] = "アクセス権限がありません"
          redirect_to tasks_path
        end
      end
  
      # ラベルのパラメータを追記して許可を出す
      def task_params
        params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
      end

      # ログインしていない状態でタスク画面にアクセスした場合、ログイン画面にリダイレクトする
      def login_required
        unless logged_in?
          flash[:danger] = "ログインしてください"
          redirect_to new_session_path
        end
      end
  end
  