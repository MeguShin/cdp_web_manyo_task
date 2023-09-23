class Task < ApplicationRecord
    # Taskモデルにuserとの関連付けを追加。ユーザーが作成したタスクを特定する。
    belongs_to :user
    validates :title, :content, :deadline_on, :priority, :status, presence: true

    # Step3から追加
    enum priority: { 低: 0, 中: 1, 高: 2}
    enum status: { 未着手:0, 着手中: 1, 完了: 2}

    # Step3から追加（検索機能）
    scope :filtered_tasks, ->(params) {
        case params[:order]
            # 「終了期限」を昇順に並び替え
            when 'deadline_on'
              @tasks = Task.order(deadline_on: :asc).page(params[:page]).per(10)
            # 「優先度」を降順に並び替え
            when 'priority'
              @tasks = Task.order(priority: :desc).page(params[:page]).per(10)
            # 上記以外
            else
              @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
            end
      
            # "title"パラメータに値があれば、その値でタイトルでフィルタリング
            if params[:title].present?
              #@tasks = @tasks.where("title LIKE ?", "%#{title}%")
              @tasks = @tasks.title_search(params[:title])
            end
            
            # "status"パラメータに値があれば、その値でフィルタリング
            if params[:status].present?
              @tasks = @tasks.where(status: params[:status])
            end
      
        @tasks = @tasks.page(params[:page]).per(10)
    }

    # タイトルのあいまい検索（文字の一部で検索が可能）
    scope :title_search, ->(title) {
        where("title LIKE ?", "%#{title}%")
    }
    # ステータス（高・中・低）で検索
    scope :status_search, ->(status) {
        where(status: status)
    }

    # Step3から追加（タイトルのあいまい検索）
    scope :search_title, ->(keyword) { where("title LIKE ?", "%#{keyword}%") }
    # Step3から追加（ステータス検索）
    scope :search_status, ->(status) { where(status: status) }
    # Step3から追加（タイトル及びステータス検索）
    scope :search_title_and_status, ->(keyword, status) {
        where("title LIKE ? AND status = ?", "%#{keyword}%", status)
    }
end
