class EntryLister
  attr_reader :entries, :title, :identifier, :filter, :feed

  def initialize(user, filter="unread", identifier="all")
    @user = user
    @filter = filter
    @identifier = identifier
  end

  def generate
    case identifier
    when 'all'
      @title = "All Feeds"
      @entries = @user.entries.order(:published)
    when 'starred'
      @title = "Starred Entries"
      @entries = @user.entries.starred.order(:published)
      @filter = "all"
    else
      @feed = @user.feeds.find(identifier)
      @title = @feed.title
      @entries = @feed.entries.order(:published)
    end
    apply_filter
  end

  private ######################################################################
  
  def apply_filter
    @entries = entries.send(@filter) if ["unread", "read"].include?(@filter)
  end
end
