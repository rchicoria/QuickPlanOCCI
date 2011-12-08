class Meeting < ActiveRecord::Base

  attr_accessor :send_to_me

  has_one :creator, :class_name => "Person", :dependent => :destroy
  has_many :topics, :class_name => "Topic", :dependent => :destroy
  accepts_nested_attributes_for :creator, :allow_destroy => true
  accepts_nested_attributes_for :topics, :allow_destroy => true
end
