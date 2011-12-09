class Meeting::Topic::Task < ActiveRecord::Base
  belongs_to :topic
  belongs_to :assignee, :class_name => "Person"

  set_table_name "meeting_tasks"
end
