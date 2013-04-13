class EntryLister
  attr_reader :entries, :title, :type, :identifier, :filter, :feed, :page
  attr_reader :entry, :prev, :next

  def initialize(user, type, filter, identifier, page=0)
    @user = user
    @type = type
    @filter = filter
    @identifier = identifier
    @page = page.to_i
  end

  def generate
    case type
    when 'folder'
      folder = @user.folders.find(identifier)
      @title = folder.name
      @entries = @user.entries.joins(:feed).where(:feeds => {:folder_id => folder.id}).order(:published => :desc)
    when 'all'
      @title = "All Items"
      @entries = @user.entries.order(:published => :desc)
    when 'starred'
      @title = "Starred Items"
      @entries = @user.entries.starred.order(:published => :desc)
      @filter = 'all'
      @type = 'starred'
    when 'feed'
      @feed = @user.feeds.find(identifier)
      @title = @feed.title
      @entries = @feed.entries.order(:published => :desc)
    end
    apply_filter
    apply_pagination
  end

  private ######################################################################

  def apply_filter
    @entries = entries.send(@filter) if ['unread','starred'].include?(@filter)
  end

  def apply_pagination
    if page > 0
      @entry = @entries.page(page).per_page(1).first
      @prev = @entries.page(page-1).per_page(1).first unless page - 1 == 0
      @next = @entries.page(page+1).per_page(1).first if @page + 1 < @entries.count
    end
  end
end
