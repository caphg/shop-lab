namespace :tasks do
    desc "Deletes obsolete tasks"
    task :delete => :environment do
        puts "Deleting tasks..."
        Item.where(done: true).where("created_at < ?", 10.days.ago).destroy_all
        puts "done."
    end
end

