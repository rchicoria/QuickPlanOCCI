class AddInvitationUrlToMeetingPeople < ActiveRecord::Migration
  def change
    add_column :meeting_people, :invitation_url, :string
  end
end
