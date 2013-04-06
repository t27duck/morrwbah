class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed

  validates_presence_of :feed, :user, :title, :url, :published, :guid

  scope :unread, -> { where(:read => false) }
  scope :starred, -> { where(:starred => true) }

  def body
    entry_body = content ? content : summary
    level = case feed.sanitization_level
    when 1
      Sanitize::Config::RELAXED
    when 2
      Sanitize::Config::BASIC
    when 3
      Sanitize::Config::RESTRICTED
    when 4
      Sanitize::Config::DEFAULT
    else
      false
    end
    level ? Sanitize.clean(entry_body, level) : entry_body
  end
end
