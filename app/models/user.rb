class User < ActiveRecord::Base
  has_secure_password

  has_many :folders, :dependent => :destroy
  has_many :feeds
  has_many :entries
 
  validates_presence_of :password, :on => :create
  validates_presence_of :login
  validates_uniqueness_of :login
  validates_presence_of :auth_token
  validates_uniqueness_of :auth_token

  before_validation :set_auth_token
  after_create :create_first_folder
 
  def fetch_feeds!
    feeds.map(&:fetch!)
    true
  end

  def all_feeds_unread_count
    @all_feeds_unread_count ||= feeds.map(&:unread_count).inject(:+).to_i
  end

  def starred_count
    @starred_count ||= entries.where(:starred => true).count
  end

  private ######################################################################

  # before_validation
  def set_auth_token
    if auth_token.blank?
      begin
        self.auth_token = SecureRandom.urlsafe_base64
      end while User.exists?(:auth_token => auth_token)
    end
  end

  # after_create
  def create_first_folder
    folders.create!(:name => 'Subscriptions')
  end
end
