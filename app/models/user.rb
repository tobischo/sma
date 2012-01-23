require 'digest/sha1'

class User < ActiveRecord::Base
  validates_length_of :name, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :name, :password, :password_confirmation, :salt
  validates_uniqueness_of :name
  validates_confirmation_of :password
  
  attr_protected :id, :salt
  
  attr_accessor :password, :password_confirmation
  
  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len){ |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
  def password=(pass)
    @passwd=pass
    self.salt = User.random_string(16) if !self.salt?
    self.password = User.encrypt(@passwd, self.salt)
  end
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end
  
  def self.authenticate(name, pass)
    u=find(:first, :conditions["name = ?", name])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt)==u.password
    nil
  end
  
end
