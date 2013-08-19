namespace :feeds  do
  desc "Fetch new entries for all feeds"
  task :fetch => :environment do
    Feed.all.map(&:fetch!)
  end

  desc "Remove all old entries"
  task :clean => :environment do
    Feed.all.map(&:clean!)
  end
end
