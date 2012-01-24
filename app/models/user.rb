require 'digest'

class User < ActiveRecord::Base
  
  attr_accessor :password
  attr_protected :id, :salt
  attr_accessible :name, :password, :password_confirmation, :loginFails
  
  validates :name,     :presence     => true,
                       :length       => {:within => 3..50},
                       :uniqueness   => true
                   
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => {:within => 6..40}
                       
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(name, submitted_password)
    u = find_by_name(name)
    return nil if u.nil?
    return u if u.has_password?(submitted_password)
  end
  
  private
  
    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
  
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
  
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end 
  
end
