class TasksController < ApplicationController
    before_action :set_task, only: %i[ show edit update destroy ]
  
    def index
      @tasks = Task.filtered_tasks(params).page(params[:page]).per(10)
      # 以下内容は、「app/models/tasks.rb」に移動
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
      @task = Task.new(task_params)
      if @task.save
        redirect_to tasks_path, notice: t('.created')
      else
        render :new
      end
    end
  
    def show
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
  
      def set_task
        @task = Task.find(params[:id])
      end
  
      def task_params
        params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
      end
  end
  