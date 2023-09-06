class Task < ApplicationRecord
    validates :title, :content, :deadline_on, :priority, :status, presence: true

    # Step3から追加
    enum priority: { 低: 0, 中: 1, 高: 2}
    enum status: { 未着手:0, 着手中: 1, 完了: 2}

    # Step3から追加（検索機能）
    scope :filtered_tasks, ->(params) {
        # 作成日時の降順で並び替え
        tasks = order(created_at: :desc)

        case params[:order]
            # 終了期限をクリックして昇順で並び替え
            when 'deadline_on'
                tasks = tasks.order(deadline_on: :asc)
            # 優先度をクリックして高い順から並び替え
            when 'priority'
                tasks = tasks.order(priority: :desc)
            end
            # タイトルが記入されている状態で検索をかけたら、タイトルに合致しているタスクのみ表示
            if params[:title].present?
                tasks = tasks.title_search(params[:title])
            end
            # ステータスが選択されている状態で検索をかけたら、ステータスの値に合致しているタスクのみ表示
            if params[:status].present?
                tasks = tasks.status_search(params[:status])
            end
        tasks
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
