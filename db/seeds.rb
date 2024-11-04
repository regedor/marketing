# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

AdminUser.create!(email: ENV["SUPER_ADMIN_EMAIL"], password: ENV["SUPER_ADMIN_PASSWORD"], password_confirmation: ENV["SUPER_ADMIN_PASSWORD"]) if Rails.env.development?

$design_idea = " Quero um trabalho geral, muito geral, totalmente geral a falar porque é que o S.C Braga é a melhor equipa do mundo #LigaPortugesa #BamboraAoPorder #SCBraga"
$copy = "Indisculivelmente o Braga é a melhor equipa do mundo, e quem acha o contrário claramente não comeu suicinhos quando era pequeno logo ficou fraco."
$comment = "Quando tu entras em campo
            De vermelho e branco
            o estádio vais ver
            sente o nosso amor
            pois este sector
            por ti vai cantar
            Força Mágico Braga
            dá um gosto à tua gente
            ver-te lá na frente
            la la la la la la la ...."
$lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
$lorem = $lorem + $lorem
$video_links = [ "https://www.youtube.com/watch?v=6Dh-RL__uN4", "https://www.youtube.com/watch?v=yYDGOdP1IJw" ]
$emails = {
    1 => [ "abhimanyu.chat@gmail.com", "andre.filipe.araujo.freitas@gmail.com" ],
    2 => [ "jmbarbosa2002@gmail.com", "zebragapt@gmail.com" ],
    3 => [ "migasfsi@gmail.com", "peradi2001@gmail.com" ],
    4 => [ "tiagoadriano.feixamoreira@gmail.com", "user1_4@gmail.com" ]
}

$pipelines = [
    "In Analysis",
    "Start",
    "In Progress",
    "Concluded"
]

$redes_sociais = [ "X", "Telegram", "Instagram", "Facebook", "Linkedin" ]
$links = [ "https://x.com/", "https://web.telegram.org/k/", "https://www.instagram.com/", "https://pt-pt.facebook.com/", "https://www.linkedin.com/" ]
$link_forms = [ "https://x.com/", "https://web.telegram.org/k/", "https://www.instagram.com/", "https://pt-pt.facebook.com/", "https://www.linkedin.com/" ]
# Add the paths for your images
$image_files = [
  Rails.root.join('db', 'images', 'sample1.jpg'),
  Rails.root.join('db', 'images', 'sample2.jpg'),
  Rails.root.join('db', 'images', 'sample3.jpg'),
  Rails.root.join('db', 'images', 'sample4.jpg'),
  Rails.root.join('db', 'images', 'sample5.jpg')
]


# Helper method to read the image and convert it to binary
def read_image_as_binary(file_path)
  File.open(file_path, "rb") { |file| file.read }
end

def create_social_platforms
  print "Creating Social Platforms:"
  1.upto(5) do |sp|
    print " #{sp}"
    Socialplatform.find_or_create_by!(name: $redes_sociais[sp-1], link: $links[sp-1], link_form: $link_forms[sp-1])
  end
  puts " done;"
end


def create_users(o, organization)
  all_users_from_organization = []
  # Create 5 users for each org, 2 leaders, 3 normal users
  print "- Leaders: "
  1.upto(2) do |n|
    print " #{$emails[o][n-1]}"
    all_users_from_organization.push($emails[o][n-1])
    User.create!(email: $emails[o][n-1], password: "1234567", password_confirmation: "1234567", isLeader: true, organization_id: organization.id)
  end
  puts " done;"
  print "- Users: "
  3.upto(5) do |n|
    print " #{n}"
    all_users_from_organization.push("user#{n}_#{o}@ww.com")
    User.create!(email: "user#{n}_#{o}@ww.com", password: "1234567", password_confirmation: "1234567", isLeader: false, organization_id: organization.id)
  end
  puts " done;"
  all_users_from_organization
end

def create_people(o, organization, all_users_from_organization)
  people_from_organization = []
  print "   - People: "
  1.upto(5) do |peoplen|
    print " #{peoplen}"
    tempbool = peoplen.even? ? true : false
    userid = User.find_by(email: all_users_from_organization[peoplen-1])

    person = Person.create!(name: "user#{peoplen}_#{o}", birthdate: Time.zone.now + rand(1..30).days, description: "Ok tudo otimo", is_private: tempbool, linkedin_link: "eu@linkdin.pt", user: userid, organization: organization)
    people_from_organization.push(person)

    1.upto(2) do |emailsp|
      tempboole1 = emailsp.even? ? true : false
      tempboole2 = emailsp.odd? ? true : false

      Email.create!(email: "user#{emailsp}_#{peoplen}@ww.com", current: tempboole1, is_active: tempboole2, person: person)
    end

    1.upto(2) do |phonep|
      tempboolpn1 = phonep.even? ? true : false
      tempboolpn2 = phonep.odd? ? true : false

      Phonenumber.create!(number: "123 456 690", current: tempboolpn1, is_active: tempboolpn2, person: person)
    end

    1.upto(2) do |notesp|
      Personnote.create!(note: $comment, person: person, user: userid)
    end
  end
  puts " done;"
  people_from_organization
end

def create_calendar(o, organization, all_users_from_organization)
  # Create 5 calendars for each org
  1.upto(5) do |c|
    puts " - Calendar #{c}"
    calendar = Calendar.find_or_create_by!(name: "Calendar #{c}", organization_id: organization.id)
    # Create 5 posts for each calendar
    1.upto(5) do |p|
      puts "   - Creating Post #{p}"
      uemail = p.even? ? $emails[o][0] : $emails[o][1]
      categories = ("a".."c").to_a # Categories as ["a", "b", "c"]
      post = Post.create!(
        title: "Post #{p}",
        user: User.find_by(email: uemail),
        design_idea: $design_idea,
        calendar: calendar,
        publish_date: Time.zone.now + rand(1..30).days,
        status: "in_analysis",
        categories: categories
      )
      # Create 5 comments for each post
      print "     - Creating Comments"
      1.upto(5) do |u|
        print " #{u}"
        usertemp = User.find_by(email: all_users_from_organization[u-1])
        Comment.create!(content: $comment, post: post, user_id: usertemp.id)
      end
      puts " done;"
      # Create the publishplatforms for every post
      print "     - Creating Publish Platforms"
      1.upto(3) do |publishplatform_num|
        socialplatform = Socialplatform.find_by(name: $redes_sociais[publishplatform_num-1], link: $links[publishplatform_num-1], link_form: $link_forms[publishplatform_num-1])
        Publishplatform.create!(socialplatform: socialplatform, post: post)
      end
      puts " done;"
      # Create 5 perspectives for each post
      0.upto(3) do |perspective_num|
        print "     - Creating Perspective #{perspective_num}"
        if perspective_num == 0
          perspective = Perspective.create!(copy: $copy, post: post)
        else
          socialplatform = Socialplatform.find_by(name: $redes_sociais[perspective_num-1])
          perspective = Perspective.create!(copy: $copy, post: post, socialplatform_id: socialplatform.id)
        end
        # Create 5 attachments for each perspective with real image content
        1.upto(3) do |attachment_num|
          print " #{attachment_num}"
          image_file_path = $image_files[attachment_num % $image_files.size]  # Cycle through the image files
          image_binary = read_image_as_binary(image_file_path)
          Attachment.create!(filename: File.basename(image_file_path), content: image_binary, perspective: perspective, type_content: "image/jpeg")
        end
        # Create 2 attachments for each perspective with cloud $links
        1.upto(2) do |attachment_num_v|
          print " #{attachment_num_v+3}"
          Attachment.create!(filename: $video_links[attachment_num_v-1], perspective: perspective, type_content: "cloud")
        end
        puts " done;"
      end
    end
  end
end

def create_company(organization, all_users_from_organization)
  ranges = [ "0-10", "10-50", "50-250", "250-1000", "1000-2500", "2500-5000", "5000-10000" ]
  numeric_ranges = ranges.map do |range|
    range.split("-").map(&:to_i)
  end
  companies_from_organization = []
  puts "  - Creating Companies and related data"
  1.upto(5) do |c|
    print "    - Creating company #{c}"
    random_range = numeric_ranges.sample
    company = Company.create!(name: "Company #{c}", employers_min: random_range[0], employers_max: random_range[1], phone_number: "123456789", url_site: "https://www.wellbeing-warrior.com/welcome", organization: organization, description: $lorem, linkedin_link: "https://www.linkedin.com/company/wellbeing-warrior/?viewAsMember=true")
    companies_from_organization.push(company)
    1.upto(5) do |cn|
      print " #{cn}"
      userid = User.find_by(email: all_users_from_organization[cn-1])
      Companynote.create!(note: $comment, company: company, user: userid)
    end
    Companylink.create!(name: "Instagram", link: "https://www.instagram.com/_wellbeing_warrior_/", company: company)
    Companylink.create!(name: "Facebook", link: "https://www.facebook.com/wellbeingw", company: company)
    puts " done;"
  end
  companies_from_organization
end

def create_person_companies(people_from_organization, companies_from_organization)
  1.upto(5) do |company|
    1.upto(3) do |person|
      pcbool = person == company
      Personcompany.create!(person: people_from_organization[person-1], company: companies_from_organization[company-1], is_working: pcbool, is_my_contact: pcbool)
    end
  end
end

def create_pipelines(organization, people_from_organization, companies_from_organization, all_users_from_organization)
  puts "  - Creating Pipelines and related data"
  1.upto(4) do |pipe|
    puts "    - Creating Pipeline #{pipe}"
    to_people = pipe % 2 == 0
    pipeline = Pipeline.create!(name: $pipelines[pipe-1], organization: organization, to_people: to_people)
    stages = [
      Stage.create!(name: "First", is_final: false, pipeline: pipeline, index: 0),
      Stage.create!(name: "Second", is_final: false, pipeline: pipeline, index: 1),
      Stage.create!(name: "Third", is_final: false, pipeline: pipeline, index: 2),
      Stage.create!(name: "Fourth", is_final: true, pipeline: pipeline, index: 3)
    ]
    pipeattributes = [
      Pipeattribute.create!(name: "First", pipeline: pipeline),
      Pipeattribute.create!(name: "Second", pipeline: pipeline),
      Pipeattribute.create!(name: "Third", pipeline: pipeline),
      Pipeattribute.create!(name: "Fourth", pipeline: pipeline)
    ]
    nl = rand(0...3)
    1.upto(nl) do |lead|
      print "      - Creating Lead #{nl}"
      st = stages.sample
      if to_people
        lead_obj = Lead.create!(name: "UMinho#{nl}_#{pipe}", start_date: Time.zone.now + rand(1..15).days, end_date: Time.zone.now + rand(15..30).days, pipeline: pipeline, person: people_from_organization[pipe-1], description: $lorem, stage: st)
      else
        lead_obj = Lead.create!(name: "UMinho#{nl}_#{pipe}", start_date: Time.zone.now + rand(1..15).days, end_date: Time.zone.now + rand(15..30).days, pipeline: pipeline, company: companies_from_organization[pipe-1], description: $lorem, stage: st)
      end
      1.upto(5) do |cn|
        print " #{cn}"
        userid = User.find_by(email: all_users_from_organization[cn-1])
        Leadnote.create!(note: $comment, lead: lead_obj, user: userid)
      end
      1.upto(4) do |lc|
        Leadcontent.create!(value: "Something", lead: lead_obj, pipeattribute: pipeattributes[lc-1])
      end
      puts "done;"
    end
  end
end

if Rails.env.development?
  create_social_platforms

  puts "Creating Organizations and related data"
  1.upto(4) do |o|
    puts "Creating Org #{o}:"
    organization = Organization.find_or_create_by!(name: "Org #{o}")

    all_users_from_organization = create_users(o, organization)
    #create_calendar(o, organization, all_users_from_organization)
    people_from_organization = create_people(o, organization, all_users_from_organization)
    companies_from_organization = create_company(organization, all_users_from_organization)
    create_person_companies(people_from_organization, companies_from_organization)
    create_pipelines(organization, people_from_organization, companies_from_organization, all_users_from_organization)
  end
  puts "Seeding complete."

end
