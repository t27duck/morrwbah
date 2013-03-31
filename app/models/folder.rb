class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :feeds

  validates_presence_of :user, :position, :name

  def unread_count
    feeds.map(&:unread_count).inject(&:+).to_i
  end
end
