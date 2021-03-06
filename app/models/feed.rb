class Feed < ActiveRecord::Base
  SANITATION_LEVELS = {
    0 => 'none',
    1 => 'relaxed',
    2 => 'basic',
    3 => 'restricted',
    4 => 'full'
  }

  belongs_to :user

  has_many :entries, :dependent => :delete_all
  
  validates_presence_of :user, :title, :sanitization_level
  
  before_validation :set_info!, :if => lambda{ |model| model.new_record? }
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

  def clean!
    entries.where(:read => true).where(:starred => false).where(["created_at <= ?", 2.days.ago]).delete_all
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

  def feed_object
    @feed_object ||= Feedzirra::Feed.fetch_and_parse(feed_url)
  end

end
