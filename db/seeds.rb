# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

AdminUser.create!(email: ENV["SUPER_ADMIN_EMAIL"], password: ENV["SUPER_ADMIN_PASSWORD"], password_confirmation: ENV["SUPER_ADMIN_PASSWORD"]) if Rails.env.development?

# Helper method to read the image and convert it to binary
def read_image_as_binary(file_path)
  File.open(file_path, "rb") { |file| file.read }
end

if Rails.env.development?
  design_idea = " Quero um trabalho geral, muito geral, totalmente geral a falar porque é que o S.C Braga é a melhor equipa do mundo #LigaPortugesa #BamboraAoPorder #SCBraga"
  copy = "Indisculivelmente o Braga é a melhor equipa do mundo, e quem acha o contrário claramente não comeu suicinhos quando era pequeno logo ficou fraco."
  comment = "Quando tu entras em campo
            De vermelho e branco
            o estádio vais ver
            sente o nosso amor
            pois este sector
            por ti vai cantar
            Força Mágico Braga
            dá um gosto à tua gente
            ver-te lá na frente
            la la la la la la la ...."

  video_links = ["https://www.youtube.com/watch?v=6Dh-RL__uN4","https://www.youtube.com/watch?v=yYDGOdP1IJw"]

  emails = {
    1 => [ "abhimanyu.chat@gmail.com", "andre.filipe.araujo.freitas@gmail.com" ],
    2 => [ "jmbarbosa2002@gmail.com", "zebragapt@gmail.com" ],
    3 => [ "migasfsi@gmail.com", "peradi2001@gmail.com" ],
    4 => [ "tiagoadriano.feixamoreira@gmail.com", "user1_4@gmail.com" ]
  }

  redes_sociais = ["X", "telegram", "intagram", "facebook", "linkdin"]
  links = ["https://x.com/","https://web.telegram.org/k/","https://www.instagram.com/","https://pt-pt.facebook.com/","https://www.linkedin.com/"]
  link_forms = ["https://x.com/i/flow/login","https://web.telegram.org/k/","https://www.instagram.com/", "https://pt-pt.facebook.com/","https://www.linkedin.com/"]
  # Add the paths for your images
  image_files = [
    Rails.root.join('db', 'images', 'sample1.jpg'),
    Rails.root.join('db', 'images', 'sample2.jpg'),
    Rails.root.join('db', 'images', 'sample3.jpg'),
    Rails.root.join('db', 'images', 'sample4.jpg'),
    Rails.root.join('db', 'images', 'sample5.jpg')
  ]

  print "Creating Social Platforms:"
  1.upto(5) do |sp|
    print " #{sp}"
    Socialplatform.find_or_create_by!(name: redes_sociais[sp-1], link:links[sp-1] , link_form:link_forms[sp-1])
  end
  puts " done;"

  puts "Creating Organizations and related data"
  1.upto(4) do |o|
    puts "Creating Org #{o}:"
    organization = Organization.find_or_create_by!(name: "Org #{o}")
    
    all_users_from_organization = []
    
    # Create 5 users for each org, 2 leaders, 3 normal users
    print "- Leaders: "
    1.upto(2) do |n|
      print " #{emails[o][n-1]}"
      all_users_from_organization.push(emails[o][n-1])
      User.create!(email: emails[o][n-1], password: "1234567", password_confirmation: "1234567", isLeader: true, organization_id: organization.id)
    end
    puts " done;"

    print "- Users: "
    3.upto(5) do |n|
      print " #{n}"
      all_users_from_organization.push("user#{n}_#{o}@ww.com")
      User.create!(email: "user#{n}_#{o}@ww.com", password: "1234567", password_confirmation: "1234567", isLeader: false, organization_id: organization.id)
    end
    puts " done;"

    # Create 5 calendars for each org
    1.upto(5) do |c|
      puts " - Calendar #{c}"
      calendar = Calendar.find_or_create_by!(name: "Calendar #{c}", organization_id: organization.id)

      # Create 5 posts for each calendar
      1.upto(5) do |p|
        puts "   - Creating Post #{p}"
        uemail = p.even? ? emails[o][0] : emails[o][1]
        categories = ("a".."c").to_a # Categories as ["a", "b", "c"]
        post = Post.create!(
          title: "Post #{p}",
          user: User.find_by(email: uemail),
          design_idea: design_idea,
          calendar: calendar,
          publish_date: Time.zone.parse('2027-07-11 21:00'),
          status: "in_analysis",
          categories: categories
        )

        # Create 5 comments for each post
        print " - Creating Comments"
        1.upto(5) do |u|
          print " #{u}"
          usertemp = User.find_by(email: all_users_from_organization[u-1])
          Comment.create!(content: comment, post: post, user_id: usertemp.id)
        end
        puts " done;"

        #Create the publishplatforms for every post
        print "- Creating  Publish Platforms"
        1.upto(5) do |publishplatform_num|
          socialplatform = Socialplatform.find_by(name: redes_sociais[publishplatform_num-1], link:links[publishplatform_num-1] , link_form:link_forms[publishplatform_num-1])
          Publishplatform.create!(socialplatform:socialplatform, post: post)
        end
        puts " done;"

        # Create 5 perspectives for each post
        0.upto(5) do |perspective_num|
          print "     - Creating Perspective #{perspective_num}"
          if perspective_num == 0
            perspective = Perspective.create!(copy: copy, post: post)
          else
            socialplatform = Socialplatform.find_by(name: redes_sociais[perspective_num-1])
            perspective = Perspective.create!(copy: copy, post: post, socialplatform_id: socialplatform.id)
          end
          
          # Create 5 attachments for each perspective with real image content
          1.upto(5) do |attachment_num|
            print " #{attachment_num}"
            image_file_path = image_files[attachment_num % image_files.size]  # Cycle through the image files
            image_binary = read_image_as_binary(image_file_path)

            Attachment.create!(filename: File.basename(image_file_path), content: image_binary, perspective: perspective, type_content: "image/jpeg")
          end
          puts " done;"
          
          # Create 2 attachments for each perspective with cloud links
          1.upto(2) do |attachment_num_v|
            print " #{attachment_num_v}"
            Attachment.create!(filename: video_links[attachment_num_v-1], perspective: perspective, type_content: "cloud")
          end
          puts " done;"
        end
      end
    end
  end
end

puts "Seeding complete."
