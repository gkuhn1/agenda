namespace :accounts do

  desc "Migra os usuários do hasMany para AccountUser"
  task :hasmany_to_accountuser => :environment do
    Account.all.each do |account|
      account.attributes["user_ids"].each do |user_id|
        AccountUser.create!(account: account, user: User.find(user_id))
        puts "."
      end
      account.attributes.delete("user_ids")
      account.save
    end
  end

end