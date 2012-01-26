class Switch < ActiveRecord::Base
  
  attr_accessible :name, :switchType, :address, :description
  attr_protected :id
  
  validates :name,     :presence     => true,
                       :uniqueness   => true
                       
  validates :switchType,     :presence     => true
                       
  validates :address,  :presence     => true
  
  
end
