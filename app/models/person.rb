class Person < ActiveRecord::Base
  belongs_to :meeting
  has_many :tasks
  
  set_table_name "meeting_people"
end
