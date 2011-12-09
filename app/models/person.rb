class Person < ActiveRecord::Base
  belongs_to :meeting
  
  set_table_name "meeting_people"
end
