class CreateMeetingTasks < ActiveRecord::Migration
  def change
    create_table :meeting_tasks do |t|
      t.integer :id
      t.string :description
      t.integer :topic_id
      t.integer :person_id

      t.timestamps
    end
  end
end
