class Meeting::Person < ActiveRecord::Base
  belongs_to :meeting
end
