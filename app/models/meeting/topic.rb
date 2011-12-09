class Meeting::Topic < ActiveRecord::Base
  belongs_to :meeting
  has_many :tasks, :dependent => :destroy
  accepts_nested_attributes_for :tasks, :allow_destroy => true, :reject_if => proc { |attributes| attributes['description'].blank? }
end
