namespace :feeds  do
  desc "Fetch new entries for all feeds"
  task :fetch => :environment do
    Feed.all.map(&:fetch!)
  end
end
