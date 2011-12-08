class CreateMeetingPeople < ActiveRecord::Migration
  def change
    create_table :meeting_people do |t|
      t.integer :id
      t.string :name
      t.string :email
      t.string :rsvp
      t.string :presence
      t.integer :meeting_id
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
