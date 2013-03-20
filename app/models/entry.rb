class Entry < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed

  validates_presence_of :feed, :user, :title, :url, :published, :entry_id
end
