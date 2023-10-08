class CreateLabelsTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :labels_tasks, id: false do |t|
      t.belongs_to :label, index: true
      t.belongs_to :task, index: true
    end
  end
end
