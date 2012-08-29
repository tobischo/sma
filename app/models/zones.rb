class Zones < ActiveRecord::Base
  
  has_many :zone_members, :class_name => "ZoneMembers"
  
  validates :name,     :presence     => true,
                       :uniqueness   => true
  
  attr_accessible :name
  attr_reader :id
end
