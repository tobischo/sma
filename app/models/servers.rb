class Servers < ActiveRecord::Base
  
  validates :name,     :presence     => true,
                       :uniqueness   => true
  
  attr_accessible :name, :os, :wwn
  attr_readonly :id
end
