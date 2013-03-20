class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_presence_of :login
  validates_uniqueness_of :login
  validates_presence_of :auth_token
  validates_uniqueness_of :auth_token

  before_validation :set_auth_token

  has_many :feeds
  has_many :entries
  
  private ######################################################################

  # before_create
  def set_auth_token
    if auth_token.blank?
      begin
        self.auth_token = SecureRandom.urlsafe_base64
      end while User.exists?(:auth_token => auth_token)
    end
  end
end
