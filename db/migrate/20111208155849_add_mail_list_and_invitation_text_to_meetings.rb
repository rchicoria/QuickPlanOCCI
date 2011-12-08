class AddMailListAndInvitationTextToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :mail_list, :text
    add_column :meetings, :invitation_text, :text
  end
end
