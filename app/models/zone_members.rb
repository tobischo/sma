class ZoneMembers < ActiveRecord::Base
  
  belongs_to :zones
  
  attr_accessible :name, :refId, :elementType, :zones_id
  attr_reader :id
end
