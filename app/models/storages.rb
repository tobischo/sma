class Storages < ActiveRecord::Base
  
  validates :name,     :presence     => true,
                       :uniqueness   => true
  
  attr_accessible :name, :wwn
  attr_readonly :id
end
