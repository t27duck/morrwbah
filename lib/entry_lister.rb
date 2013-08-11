class EntryLister
  attr_reader :entries, :title, :type, :identifier, :filter, :feed

  def initialize(user, type="all", filter="unread", identifier=nil)
    @user = user
    @type = type
    @filter = filter
    @identifier = identifier
  end

  def generate
    case @type
    when 'all'
      @title = "All Items"
      @entries = @user.entries.order(:published)
    when 'starred'
      @title = "Starred Items"
      @entries = @user.entries.starred.order(:published)
      @filter = 'all'
      @type = 'starred'
    else
      @feed = @user.feeds.find(identifier)
      @title = @feed.title
      @entries = @feed.entries.order(:published)
    end
    apply_filter
  end

  private ######################################################################
  
  def apply_filter
    @entries = entries.send(@filter) if ['unread','starred'].include?(@filter)
  end
end
