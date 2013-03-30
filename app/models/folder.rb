class Folder < ActiveRecord::Base
  belongs_to :user
  has_many :feeds

  validates_presence_of :user, :position, :name
end
