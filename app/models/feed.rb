class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :entries, :dependent => :delete_all

  validates_presence_of :user, :title, :feed_url, :last_modified

  def set_info!
    if feed_object.respond_to?(:title)
      self.title         = feed_object.title
      self.url           = feed_object.url
      self.etag          = feed_object.etag
      self.last_modified = feed_object.last_modified
    end
  end

  def fetch!
    create_new_entries!
    self.last_checked = Time.now
    set_info!
    save!
  end

  private ######################################################################

  def create_new_entries!
    feed_object.entries.each do |e|
      unless Entry.exists?(:feed_id => id, :user_id => user_id, :entry_id => e.entry_id)
        Entry.create!({
          :feed_id   => id,
          :user_id   => user_id,
          :title     => e.title,
          :url       => e.url,
          :author    => e.author,
          :published => e.published,
          :entry_id  => e.entry_id,
          :summary   => e.summary,
          :content   => e.content
        })
      end
    end
  end

  def feed_object
    @feed_object ||= Feedzirra::Feed.fetch_and_parse(feed_url)
  end
end
