class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed

  validates_presence_of :feed, :user, :title, :url, :published, :guid

  scope :unread, -> { where(:read => false) }
  scope :starred, -> { where(:starred => true) }

  def body
    content ? content : summary
  end
end
