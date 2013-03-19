class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_presence_of :login
  validates_uniqueness_of :login
  validates_presence_of :auth_token
  validates_uniqueness_of :auth_token

  before_create :generate_token

  has_many :feeds
  has_many :entries
  
  private ######################################################################

  def generate_token(column)
    begin
      self[:auth_token] = SecureRandom.urlsafe_base64
    end while User.exists?(:auth_token => self[:auth_token])
  end
end
