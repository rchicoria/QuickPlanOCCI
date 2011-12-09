class AddManagementUrlToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :management_url, :string
  end
end
