class CreateMeetingTopics < ActiveRecord::Migration
  def change
    create_table :meeting_topics do |t|
      t.integer :id
      t.string :name
      t.string :description
      t.integer :meeting_id
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
