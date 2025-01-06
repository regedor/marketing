# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).


organization = Organization.find_or_create_by!(name: "Wellbeing Warrior", slack_workspace_token: ENV['BOT_TOKEN'],
  slack_channel: ENV['BOT_CHANNEL'])

emails = %w[miguel.regedor@regedor.com luisa.vieira@regedor.com hugo.marinho@regedor.com diogo.araujo@regedor.com
  tiago.freitas@regedor.com nicoleta.domenti@regedor.com]

emails.each do |email|
  User.create!(email: email, password: "password123", password_confirmation: "password123",
    isLeader: true, organization: organization)
  AdminUser.create!(email: email, password: "password123")
end

$calendar = Calendar.find_or_create_by!(name: "Wellbeing Warrior", organization: organization)

$social_platforms = [ "X", "Telegram", "Instagram", "Facebook", "Linkedin" ]
$social_platforms_links = [ "https://x.com/", "https://web.telegram.org/k/", "https://www.instagram.com/", "https://pt-pt.facebook.com/", "https://www.linkedin.com/" ]
$link_forms = [ "https://x.com/", "https://web.telegram.org/k/", "https://www.instagram.com/", "https://pt-pt.facebook.com/", "https://www.linkedin.com/" ]

def create_social_platforms
  $social_platforms.each_with_index do |sp, index|
    Socialplatform.find_or_create_by!(name: sp, link: $social_platforms_links[index], link_form: $link_forms[index])
  end
end


create_social_platforms

# def create_calendar(o, organization, all_users_from_organization)
#   # Create 5 calendars for each org
#   1.upto(5) do |c|
#     puts " - Calendar #{c}"
#     calendar = Calendar.find_or_create_by!(name: "Calendar #{c}", organization_id: organization.id)
#     # Create 5 posts for each calendar
#     1.upto(5) do |p|
#       puts "   - Creating Post #{p}"
#       uemail = p.even? ? $emails[o][0] : $emails[o][1]
#       categories = ("a".."c").to_a # Categories as ["a", "b", "c"]
#       post = Post.create!(
#         title: "Post #{p}",
#         user: User.find_by(email: uemail),
#         design_idea: $design_idea,
#         calendar: calendar,
#         publish_date: Time.zone.now + rand(1..30).days,
#         status: "in_analysis",
#         categories: categories
#       )
#       # Create 5 comments for each post
#       print "     - Creating Comments"
#       1.upto(5) do |u|
#         print " #{u}"
#         usertemp = User.find_by(email: all_users_from_organization[u-1])
#         Comment.create!(content: $comment, post: post, user_id: usertemp.id)
#       end
#       puts " done;"
#       # Create the publishplatforms for every post
#       print "     - Creating Publish Platforms"
#       1.upto(3) do |publishplatform_num|
#         socialplatform = Socialplatform.find_by(name: $redes_sociais[publishplatform_num-1], link: $links[publishplatform_num-1], link_form: $link_forms[publishplatform_num-1])
#         Publishplatform.create!(socialplatform: socialplatform, post: post)
#       end
#       puts " done;"
#       # Create 5 perspectives for each post
#       0.upto(3) do |perspective_num|
#         print "     - Creating Perspective #{perspective_num}"
#         if perspective_num == 0
#           perspective = Perspective.create!(copy: $copy, post: post)
#         else
#           socialplatform = Socialplatform.find_by(name: $redes_sociais[perspective_num-1])
#           perspective = Perspective.create!(copy: $copy, post: post, socialplatform_id: socialplatform.id)
#         end
#         # Create 5 attachments for each perspective with real image content
#         1.upto(3) do |attachment_num|
#           print " #{attachment_num}"
#           image_file_path = $image_files[attachment_num % $image_files.size]  # Cycle through the image files
#           image_binary = read_image_as_binary(image_file_path)
#           Attachment.create!(filename: File.basename(image_file_path), content: image_binary, perspective: perspective, type_content: "image/jpeg")
#         end
#         # Create 2 attachments for each perspective with cloud $links
#         1.upto(2) do |attachment_num_v|
#           print " #{attachment_num_v+3}"
#           Attachment.create!(filename: $video_links[attachment_num_v-1], perspective: perspective, type_content: "cloud")
#         end
#         puts " done;"
#       end
#     end
#   end
# end

# def create_company(organization, all_users_from_organization)
#   ranges = [ "0-10", "10-50", "50-250", "250-1000", "1000-2500", "2500-5000", "5000-10000" ]
#   numeric_ranges = ranges.map do |range|
#     range.split("-").map(&:to_i)
#   end
#   companies_from_organization = []
#   puts "  - Creating Companies and related data"
#   1.upto(5) do |c|
#     print "    - Creating company #{c}"
#     random_range = numeric_ranges.sample
#     company = Company.create!(name: "Company #{c}", employers_min: random_range[0], employers_max: random_range[1], phone_number: "123456789", url_site: "https://www.wellbeing-warrior.com/welcome", organization: organization, description: $lorem, linkedin_link: "https://www.linkedin.com/company/wellbeing-warrior/?viewAsMember=true")
#     companies_from_organization.push(company)
#     1.upto(5) do |cn|
#       print " #{cn}"
#       userid = User.find_by(email: all_users_from_organization[cn-1])
#       Companynote.create!(note: $comment, company: company, user: userid)
#     end
#     Companylink.create!(name: "Instagram", link: "https://www.instagram.com/_wellbeing_warrior_/", company: company)
#     Companylink.create!(name: "Facebook", link: "https://www.facebook.com/wellbeingw", company: company)
#     puts " done;"
#   end
#   companies_from_organization
# end

# def create_person_companies(people_from_organization, companies_from_organization)
#   1.upto(5) do |company|
#     1.upto(3) do |person|
#       pcbool = person == company
#       Personcompany.create!(person: people_from_organization[person-1], company: companies_from_organization[company-1], is_working: pcbool, is_my_contact: pcbool)
#     end
#   end
# end

# def create_pipelines(organization, people_from_organization, companies_from_organization, all_users_from_organization)
#   puts "  - Creating Pipelines and related data"
#   1.upto(4) do |pipe|
#     puts "    - Creating Pipeline #{pipe}"
#     to_people = pipe % 2 == 0
#     pipeline = Pipeline.create!(name: $pipelines[pipe-1], organization: organization, to_people: to_people)
#     stages = [
#       Stage.create!(name: "First", is_final: false, pipeline: pipeline, index: 1),
#       Stage.create!(name: "Second", is_final: false, pipeline: pipeline, index: 2),
#       Stage.create!(name: "Third", is_final: false, pipeline: pipeline, index: 3),
#       Stage.create!(name: "Fourth", is_final: true, pipeline: pipeline, index: 4)
#     ]
#     pipeattributes = [
#       Pipeattribute.create!(name: "First", pipeline: pipeline),
#       Pipeattribute.create!(name: "Second", pipeline: pipeline),
#       Pipeattribute.create!(name: "Third", pipeline: pipeline),
#       Pipeattribute.create!(name: "Fourth", pipeline: pipeline)
#     ]
#     nl = rand(0...3)
#     1.upto(nl) do |lead|
#       print "      - Creating Lead #{nl}"
#       st = stages.sample
#       if to_people
#         lead_obj = Lead.create!(name: "UMinho#{nl}_#{pipe}", start_date: Time.zone.now + rand(1..15).days, end_date: Time.zone.now + rand(15..30).days, pipeline: pipeline, person: people_from_organization[pipe-1], description: $lorem, stage: st)
#       else
#         lead_obj = Lead.create!(name: "UMinho#{nl}_#{pipe}", start_date: Time.zone.now + rand(1..15).days, end_date: Time.zone.now + rand(15..30).days, pipeline: pipeline, company: companies_from_organization[pipe-1], description: $lorem, stage: st)
#       end
#       1.upto(5) do |cn|
#         print " #{cn}"
#         userid = User.find_by(email: all_users_from_organization[cn-1])
#         Leadnote.create!(note: $comment, lead: lead_obj, user: userid)
#       end
#       1.upto(4) do |lc|
#         Leadcontent.create!(value: "Something", lead: lead_obj, pipeattribute: pipeattributes[lc-1])
#       end
#       puts "done;"
#     end
#   end
# end

# def test_seed
#   create_social_platforms

#   puts "Creating Organizations and related data"
#   1.upto(4) do |o|
#     puts "Creating Org #{o}:"
#     organization = Organization.find_or_create_by!(name: "Org #{o}", slack_workspace_token: ENV['BOT_TOKEN'], slack_channel: "pei-test")

#     all_users_from_organization = create_users(o, organization)
#     create_calendar(o, organization, all_users_from_organization)
#     people_from_organization = create_people(o, organization, all_users_from_organization)
#     companies_from_organization = create_company(organization, all_users_from_organization)
#     create_person_companies(people_from_organization, companies_from_organization)
#     create_pipelines(organization, people_from_organization, companies_from_organization, all_users_from_organization)
#   end
#   puts "Seeding complete."
# end

# def demo_create_calendar_ww(organization, userJMF, userREG, userSTD)
#   x = 1
#   telegram = 2
#   instagram = 3
#   facebook = 4
#   linkedin = 5

#   calendarWW = Calendar.find_or_create_by!(name: "Wellbeing Warrior", organization_id: organization.id)

#   post4 = Post.create!(title: "UMinho", user: userJMF, design_idea: "Um diagrama UML de sequência moderno.", calendar: calendarWW, publish_date: DateTime.new(2024, 11, 12, 9, 30), status: "in_analysis", categories: [ "RAS", "UMinho" ])
#   Comment.create!(content: "Excelente ideia, adorei RAS!", post: post4, user_id: userREG.id)
#   Comment.create!(content: "Bom sim de facto é uma ideia interessante.", post: post4, user_id: userSTD.id)
#   Publishplatform.create!(socialplatform_id: x, post: post4)
#   Publishplatform.create!(socialplatform_id: linkedin, post: post4)
#   Perspective.create!(copy: "Isto sim é engenharia, modelar software.", post: post4)
#   Perspective.create!(copy: "Que experiencia boa!!", post: post4, socialplatform_id: linkedin)
#   Perspective.create!(copy: "Incrivel diagramas, são simplesmente inacreditaveis!", post: post4, socialplatform_id: x)

#   post5 = Post.create!(title: "Viagem Alemanha",  user: userREG, design_idea: "Pôr uma foto do Portão de Brandemburgo.", calendar: calendarWW, publish_date: DateTime.new(2024, 11, 13, 23, 44), status: "in_analysis", categories: [ "Alemanha", "Startup" ])
#   Comment.create!(content: "Muito Bonito, é quase tão como o arco da porta nova :).", post: post5, user_id: userJMF.id)
#   Comment.create!(content: "Espetacular a Alemanha parece ser muito bonita!", post: post5, user_id: userSTD.id)
#   Publishplatform.create!(socialplatform_id: telegram, post: post5)
#   Publishplatform.create!(socialplatform_id: instagram, post: post5)
#   post5Default = Perspective.create!(copy: "Esta viagem à Alemanha foi fenomenal", post: post5)
#   Attachment.create!(filename: File.basename(Rails.root.join('db', 'images', 'sample4.jpg')), content: demo_binary_img(Rails.root.join('db', 'images', 'sample4.jpg')), perspective: post5Default, type_content: "image/jpeg")
#   Attachment.create!(filename: $video_links[1], perspective: post5Default, type_content: "cloud")
#   post5Instagram = Perspective.create!(copy: "Alemanha? EXCELENTEEEE!", post: post5, socialplatform_id: instagram)
#   Attachment.create!(filename: File.basename(Rails.root.join('db', 'images', 'sample5.jpg')), content: demo_binary_img(Rails.root.join('db', 'images', 'sample5.jpg')), perspective: post5Instagram, type_content: "image/jpeg")
#   Attachment.create!(filename: $video_links[0], perspective: post5Instagram, type_content: "cloud")
#   Attachment.create!(filename: $video_links[1], perspective: post5Instagram, type_content: "cloud")


#   post6 = Post.create!(title: "Compras", user: userSTD, design_idea: "Mostrar uma foto dos preços dos pacotes de leite.", calendar: calendarWW, publish_date: DateTime.new(2024, 11, 5, 22, 00), status: "in_analysis", categories: [ "Inflação", "Super mercado" ])
#   Comment.create!(content: "De facto os preços estão loucos!", post: post6, user_id: userREG.id)
#   Publishplatform.create!(socialplatform_id: facebook, post: post6)
#   Publishplatform.create!(socialplatform_id: linkedin, post: post6)
#   Publishplatform.create!(socialplatform_id: instagram, post: post6)
#   post6Default = Perspective.create!(copy: "A inflação está a afetar de forma drástica os preços dos laticínios.", post: post6)
#   Attachment.create!(filename: File.basename(Rails.root.join('db', 'images', 'sample3.jpg')), content: demo_binary_img(Rails.root.join('db', 'images', 'sample3.jpg')), perspective: post6Default, type_content: "image/jpeg")
#   Attachment.create!(filename: File.basename(Rails.root.join('db', 'images', 'sample4.jpg')), content: demo_binary_img(Rails.root.join('db', 'images', 'sample4.jpg')), perspective: post6Default, type_content: "image/jpeg")
#   Attachment.create!(filename: File.basename(Rails.root.join('db', 'images', 'engagelogo.png')), content: demo_binary_img(Rails.root.join('db', 'images', 'engagelogo.png')), perspective: post6Default, type_content: "image/png")
#   Attachment.create!(filename: File.basename(Rails.root.join('db', 'images', 'react.png')), content: demo_binary_img(Rails.root.join('db', 'images', 'react.png')), perspective: post6Default, type_content: "image/png")
#   Attachment.create!(filename: File.basename(Rails.root.join('db', 'images', 'sample4.jpg')), content: demo_binary_img(Rails.root.join('db', 'images', 'sample5.jpg')), perspective: post6Default, type_content: "image/jpeg")
#   Attachment.create!(filename: $video_links[0], perspective: post6Default, type_content: "cloud")
# end

# def demo_create_pipeline_sells(organization, userJMF, userREG, userSTD, company1)
#   pipeline1 = Pipeline.create!(name: "Vendas", organization: organization, to_people: false)
#   stages1 = [
#     Stage.create!(name: "Primeiro Contacto", is_final: false, pipeline: pipeline1, index: 1),
#     Stage.create!(name: "Mensagem Enviada", is_final: false, pipeline: pipeline1, index: 2),
#     Stage.create!(name: "Testar", is_final: false, pipeline: pipeline1, index: 3),
#     Stage.create!(name: "Fechado", is_final: true, pipeline: pipeline1, index: 4)
#   ]
#   pipeattributes1 = [
#     Pipeattribute.create!(name: "Dados", pipeline: pipeline1),
#     Pipeattribute.create!(name: "Conhecimento", pipeline: pipeline1),
#     Pipeattribute.create!(name: "Dinheiro", pipeline: pipeline1),
#     Pipeattribute.create!(name: "Informação Basica", pipeline: pipeline1)
#   ]
#   leads1 = [
#     Lead.create!(name: "Pingo Doce", start_date: DateTime.new(2024, 11, 8, 9, 30), end_date: DateTime.new(2024, 11, 12, 9, 30), pipeline: pipeline1, company: company1, description: "Venda muito importante", stage: stages1[0])
#   ]
#   Leadcontent.create!(value: "Hiper mercado Portuguesa", lead: leads1[0], pipeattribute: pipeattributes1[0])
#   Leadcontent.create!(value: "Excelentes Promoções", lead: leads1[0], pipeattribute: pipeattributes1[1])
#   Leadcontent.create!(value: "10 000 000€", lead: leads1[0], pipeattribute: pipeattributes1[2])
#   Leadcontent.create!(value: "", lead: leads1[0], pipeattribute: pipeattributes1[3])
#   Leadnote.create!(note: "Empresa muito conhecida no mercado nacional. Não podemos falhar.", lead: leads1[0], user: userSTD)
# end

# def demo_create_pipeline_buy(organization, userJMF, userREG, userSTD, person1, person2, person3)
#   pipeline2 = Pipeline.create!(name: "Compras", organization: organization, to_people: true)
#   stages2 = [
#     Stage.create!(name: "Primeira Venda", is_final: false, pipeline: pipeline2, index: 1),
#     Stage.create!(name: "Email Enviado", is_final: false, pipeline: pipeline2, index: 2),
#     Stage.create!(name: "Testar", is_final: false, pipeline: pipeline2, index: 3),
#     Stage.create!(name: "Fechado", is_final: true, pipeline: pipeline2, index: 4)
#   ]
#   pipeattributes2 = [
#     Pipeattribute.create!(name: "Dinheiro", pipeline: pipeline2),
#     Pipeattribute.create!(name: "Informação Basica", pipeline: pipeline2)
#   ]
#   leads2 = [
#     Lead.create!(name: "WW", start_date: DateTime.new(2024, 11, 12, 9, 30), end_date: DateTime.new(2024, 11, 12, 9, 30), pipeline: pipeline2, person: person3, description: "Empreendedor português ajuda alemães a serem mais felizes no trabalho", stage: stages2[0]),
#     Lead.create!(name: "UM", start_date: DateTime.new(2024, 11, 19, 14, 40), end_date: DateTime.new(2024, 11, 24, 12, 45), pipeline: pipeline2, person: person2, description: "Excelente universidade", stage: stages2[0]),
#     Lead.create!(name: "SCB", start_date: DateTime.new(2024, 11, 21, 15, 10), end_date: DateTime.new(2024, 11, 30, 18, 00), pipeline: pipeline2, person: person1, description: "Clube do norte de Portugual, mais precisamente da cidade de Braga", stage: stages2[2])
#   ]

#   Leadcontent.create!(value: "1 000 000€", lead: leads2[0], pipeattribute: pipeattributes2[0])
#   Leadcontent.create!(value: "Startup de Braga", lead: leads2[0], pipeattribute: pipeattributes2[1])

#   Leadcontent.create!(value: "", lead: leads2[1], pipeattribute: pipeattributes2[0])
#   Leadcontent.create!(value: "Univesidade Portuguesa", lead: leads2[1], pipeattribute: pipeattributes2[1])

#   Leadcontent.create!(value: "127 000 000€", lead: leads2[2], pipeattribute: pipeattributes2[0])
#   Leadcontent.create!(value: "Cidade Desportiva, Dume, Braga", lead: leads2[2], pipeattribute: pipeattributes2[1])

#   Leadnote.create!(note: "Empresa do responsavel pelo Projeto", lead: leads2[0], user: userJMF)
#   Leadnote.create!(note: "Universidade que frequento", lead: leads2[1], user: userJMF)
#   Leadnote.create!(note: "#RicardoHorta21", lead: leads2[0], user: userSTD)
# end
