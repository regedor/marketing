# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_03_14_105850) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "attachmentcounters", force: :cascade do |t|
    t.bigint "attachment_id", null: false
    t.bigint "user_id", null: false
    t.boolean "aproved", default: false
    t.boolean "rejected", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_id"], name: "index_attachmentcounters_on_attachment_id"
    t.index ["user_id"], name: "index_attachmentcounters_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "perspective_id", null: false
    t.string "filename"
    t.string "type_content"
    t.binary "content"
    t.string "status", default: "in_analysis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "attachment_id"
    t.index ["attachment_id"], name: "index_attachments_on_attachment_id"
    t.index ["perspective_id"], name: "index_attachments_on_perspective_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_calendars_on_organization_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.integer "employers_min", default: 0
    t.integer "employers_max", default: 0
    t.string "phone_number"
    t.string "url_site"
    t.string "linkedin_link"
    t.text "description"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_companies_on_organization_id"
  end

  create_table "companylinks", primary_key: ["company_id", "name"], force: :cascade do |t|
    t.string "name", null: false
    t.string "link"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_companylinks_on_company_id"
  end

  create_table "companynotes", force: :cascade do |t|
    t.text "note"
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_companynotes_on_company_id"
    t.index ["user_id"], name: "index_companynotes_on_user_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "email"
    t.boolean "current"
    t.boolean "is_active"
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_emails_on_person_id"
  end

  create_table "leadcontents", force: :cascade do |t|
    t.string "value"
    t.bigint "lead_id", null: false
    t.bigint "pipeattribute_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lead_id"], name: "index_leadcontents_on_lead_id"
    t.index ["pipeattribute_id"], name: "index_leadcontents_on_pipeattribute_id"
  end

  create_table "leadnotes", force: :cascade do |t|
    t.text "note"
    t.bigint "lead_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lead_id"], name: "index_leadnotes_on_lead_id"
    t.index ["user_id"], name: "index_leadnotes_on_user_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.bigint "pipeline_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.bigint "person_id"
    t.bigint "stage_id", null: false
    t.text "description"
    t.index ["company_id"], name: "index_leads_on_company_id"
    t.index ["person_id"], name: "index_leads_on_person_id"
    t.index ["pipeline_id"], name: "index_leads_on_pipeline_id"
    t.index ["stage_id"], name: "index_leads_on_stage_id"
  end

  create_table "log_entries", force: :cascade do |t|
    t.string "controller_name"
    t.text "info"
    t.datetime "created_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.text "description"
    t.bigint "organization_id", null: false
    t.boolean "sent", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "title"
    t.index ["organization_id"], name: "index_notifications_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slack_workspace_token"
    t.string "slack_channel"
    t.string "slug", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.date "birthdate"
    t.text "description"
    t.boolean "is_private"
    t.string "linkedin_link"
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_people_on_organization_id"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "personcompanies", primary_key: ["person_id", "company_id"], force: :cascade do |t|
    t.boolean "is_working"
    t.boolean "is_my_contact"
    t.bigint "person_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_personcompanies_on_company_id"
    t.index ["person_id"], name: "index_personcompanies_on_person_id"
  end

  create_table "personlinks", primary_key: ["person_id", "name"], force: :cascade do |t|
    t.string "name", null: false
    t.string "link"
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_personlinks_on_person_id"
  end

  create_table "personnotes", force: :cascade do |t|
    t.text "note"
    t.bigint "person_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_personnotes_on_person_id"
    t.index ["user_id"], name: "index_personnotes_on_user_id"
  end

  create_table "perspectives", force: :cascade do |t|
    t.text "copy"
    t.bigint "post_id", null: false
    t.bigint "socialplatform_id"
    t.string "status", default: "in_analysis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_perspectives_on_post_id"
    t.index ["socialplatform_id"], name: "index_perspectives_on_socialplatform_id"
  end

  create_table "phonenumbers", force: :cascade do |t|
    t.string "number"
    t.boolean "current"
    t.boolean "is_active"
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_phonenumbers_on_person_id"
  end

  create_table "pipeattributes", force: :cascade do |t|
    t.string "name"
    t.bigint "pipeline_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_pipeattributes_on_pipeline_id"
  end

  create_table "pipelines", force: :cascade do |t|
    t.string "name"
    t.boolean "to_people"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_pipelines_on_organization_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "design_idea"
    t.string "categories", default: [], array: true
    t.bigint "user_id", null: false
    t.bigint "calendar_id", null: false
    t.string "status", default: "draft"
    t.datetime "publish_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_posts_on_calendar_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "publishplatforms", primary_key: ["socialplatform_id", "post_id"], force: :cascade do |t|
    t.bigint "socialplatform_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_publishplatforms_on_post_id"
    t.index ["socialplatform_id"], name: "index_publishplatforms_on_socialplatform_id"
  end

  create_table "socialplatforms", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.string "link_form"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stages", force: :cascade do |t|
    t.string "name"
    t.boolean "is_final", default: false
    t.integer "index"
    t.bigint "pipeline_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_stages_on_pipeline_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.boolean "isLeader", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attachmentcounters", "attachments"
  add_foreign_key "attachmentcounters", "users"
  add_foreign_key "attachments", "attachments"
  add_foreign_key "attachments", "perspectives"
  add_foreign_key "calendars", "organizations"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "companies", "organizations"
  add_foreign_key "companylinks", "companies"
  add_foreign_key "companynotes", "companies"
  add_foreign_key "companynotes", "users"
  add_foreign_key "emails", "people"
  add_foreign_key "leadcontents", "leads"
  add_foreign_key "leadcontents", "pipeattributes"
  add_foreign_key "leadnotes", "leads"
  add_foreign_key "leadnotes", "users"
  add_foreign_key "leads", "companies"
  add_foreign_key "leads", "people"
  add_foreign_key "leads", "pipelines"
  add_foreign_key "leads", "stages"
  add_foreign_key "notifications", "organizations"
  add_foreign_key "people", "organizations"
  add_foreign_key "people", "users"
  add_foreign_key "personcompanies", "companies"
  add_foreign_key "personcompanies", "people"
  add_foreign_key "personlinks", "people"
  add_foreign_key "personnotes", "people"
  add_foreign_key "personnotes", "users"
  add_foreign_key "perspectives", "posts"
  add_foreign_key "perspectives", "socialplatforms"
  add_foreign_key "phonenumbers", "people"
  add_foreign_key "pipeattributes", "pipelines"
  add_foreign_key "pipelines", "organizations"
  add_foreign_key "posts", "calendars"
  add_foreign_key "posts", "users"
  add_foreign_key "publishplatforms", "posts"
  add_foreign_key "publishplatforms", "socialplatforms"
  add_foreign_key "stages", "pipelines"
end
