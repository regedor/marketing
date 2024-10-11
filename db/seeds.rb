# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: ENV["SUPER_ADMIN_EMAIL"], password: ENV["SUPER_ADMIN_PASSWORD"], password_confirmation: ENV["SUPER_ADMIN_PASSWORD"]) if Rails.env.development?

if Rails.env.development?
  text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. #PI #MEI #UMINHO"
  # create 5 orgs
  for o in 1..5 do
    puts "Creating Org " + o.to_s + ":"
    Organization.create!(name: "Org " + o.to_s)
    # creates 5 users for each org, 2 leaders, 3 normal users
    print "- Users: "
    for n in 1..2 do
      print n.to_s + " "
      User.create!(email: "user" + n.to_s + "_" + o.to_s + "@ww.com", password: "1234567", password_confirmation: "1234567", isLeader: true, organization_id: o)
    end
    for n in 3..5 do
      print n.to_s + " "
      User.create!(email: "user" + n.to_s + "_" + o.to_s + "@ww.com", password: "1234567", password_confirmation: "1234567", isLeader: false, organization_id: o)
    end
    puts "done;"
    puts "- Calendars: "
    # create 5 calendars for each org
    for c in 1..5 do
      print " - " + c.to_s + " posts: "
      calendar = Calendar.create!(name: "Calendar " + c.to_s, organization_id: o)
      # create 5 posts for each calendar
      for p in 1..5 do
        print p.to_s + " "
        if p % 2 == 0
          uid = 1
        else
          uid = 2
        end
        post = Post.create!(title: "Post " + p.to_s, user_id: uid, design_idea: text, calendar: calendar, publish_date: Time.zone.parse('2027-07-11 21:00'), status: "in_analysis")
        for u in 1..5 do
          Comment.create!(content: text, post: post, user_id: u)
        end
      end
      puts "done;"
    end
  end
end
