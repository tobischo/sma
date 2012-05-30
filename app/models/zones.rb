class Zones < ActiveRecord::Base
  
  has_many :zone_members, :class_name => "ZoneMembers"
  
  validates :name,     :presence     => true,
                       :uniqueness   => true
  
end
