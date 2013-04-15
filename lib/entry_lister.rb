class EntryLister
  attr_reader :entries, :title, :type, :identifier, :filter, :feed

  def initialize(user, type, filter, identifier)
    @user = user
    @type = type
    @filter = filter
    @identifier = identifier
  end

  def generate
    case @type
    when 'all'
      @title = "All Items"
      @entries = @user.entries.order(:published => :desc)
    when 'starred'
      @title = "Starred Items"
      @entries = @user.entries.starred.order(:published => :desc)
      @filter = 'all'
      @type = 'starred'
    when 'folder'
      folder = @user.folders.find(identifier)
      @title = folder.name
      @entries = @user.entries.joins(:feed).where(:feeds => {:folder_id => folder.id}).order(:published => :desc)
    else
      @feed = @user.feeds.find(identifier)
      @title = @feed.title
      @entries = @feed.entries.order(:published => :desc)
    end
    apply_filter
  end

  private ######################################################################
  
  def apply_filter
    @entries = entries.send(@filter) if ['unread','starred'].include?(@filter)
  end
end
