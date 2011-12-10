class Person < ActiveRecord::Base
  belongs_to :meeting
  has_many :tasks
  
  set_table_name "meeting_people"

  validates_presence_of :name  
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
