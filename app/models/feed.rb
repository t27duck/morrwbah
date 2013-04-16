require 'net/http'
class Feed < ActiveRecord::Base
  SANITATION_LEVELS = {
    0 => 'none',
    1 => 'relaxed',
    2 => 'basic',
    3 => 'restricted',
    4 => 'full'
  }

  belongs_to :user
  belongs_to :folder

  has_many :entries, :dependent => :delete_all
  
  validates_presence_of :user, :folder, :title, :sanitization_level
  
  before_validation :set_info!, :set_icon, :if => lambda{ |model| model.new_record? }
  after_create :fetch!
  

  def set_info!
    if feed_object.respond_to?(:title)
      self.title         = feed_object.title
      self.url           = feed_object.url
      self.etag          = feed_object.etag
      self.last_modified = feed_object.last_modified
    else
      self.errors.add(:base, 'Unable to parse feed')
    end
  end

  def fetch!
    create_new_entries!
    self.last_checked = Time.now
    save!
  end

  def unread_count
    @unread_count ||= entries.unread.count
  end

  private ######################################################################

  def create_new_entries!
    feed_object.entries.each do |e|
      identifier = e.entry_id if e.respond_to?(:entry_id)  
      identifier ||= e.guid if e.respond_to?(:guid)
      identifier ||= e.url

      unless Entry.exists?(:feed_id => id, :user_id => user_id, :guid => identifier)
        Entry.create!({
          :feed_id   => id,
          :user_id   => user_id,
          :title     => e.title,
          :url       => e.url,
          :author    => e.author,
          :published => e.published,
          :guid      => identifier,
          :summary   => e.summary,
          :content   => e.respond_to?(:content) ? e.content : nil
        })
      end
    end
  rescue
    self.errors.add(:base, 'There was an error parsing entries in this feed')
    raise
  end

  def set_icon
    self.icon_path = remote_favicon_url(url) || '/images/default_feed_icon.png'
  end

  def feed_object
    @feed_object ||= Feedzirra::Feed.fetch_and_parse(feed_url)
  end

  def remote_favicon_url(feed_url)
    uri = URI.parse(feed_url)
    uri = URI.parse("http://#{feed_url}") if uri.scheme.nil?
    host = uri.host.downcase
    use_ssl = false
    if url.include?("https://")
      use_ssl = true
      favicon_url = "https://#{host}/favicon.ico"
    else
      favicon_url = "http://#{host}/favicon.ico"
    end
 
    uri = URI.parse(favicon_url)
    response = nil
    http = Net::HTTP.new uri.host, uri.port
    if use_ssl
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
    end
    http.start{|http|
      response = http.head(uri.path)
    }
    response.code == "200" ? favicon_url : nil
  rescue
    nil
  end

end
