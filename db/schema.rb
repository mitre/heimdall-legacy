# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_25_111745) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aspects", force: :cascade do |t|
    t.string "name"
    t.text "options"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_aspects_on_profile_id"
  end

  create_table "circles", force: :cascade do |t|
    t.string "name"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "circles_evaluations", id: false, force: :cascade do |t|
    t.bigint "circle_id", null: false
    t.bigint "evaluation_id", null: false
    t.index ["circle_id", "evaluation_id"], name: "index_circles_evaluations_on_circle_id_and_evaluation_id"
    t.index ["evaluation_id", "circle_id"], name: "index_circles_evaluations_on_evaluation_id_and_circle_id"
  end

  create_table "circles_profiles", id: false, force: :cascade do |t|
    t.bigint "circle_id", null: false
    t.bigint "profile_id", null: false
    t.index ["circle_id", "profile_id"], name: "index_circles_profiles_on_circle_id_and_profile_id"
    t.index ["profile_id", "circle_id"], name: "index_circles_profiles_on_profile_id_and_circle_id"
  end

  create_table "controls", force: :cascade do |t|
    t.string "title"
    t.string "desc"
    t.string "impact"
    t.text "refs"
    t.text "code"
    t.string "control_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "waiver_data"
    t.index ["profile_id"], name: "index_controls_on_profile_id"
  end

  create_table "controls_groups", id: false, force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "control_id", null: false
    t.index ["control_id", "group_id"], name: "index_controls_groups_on_control_id_and_group_id"
    t.index ["group_id", "control_id"], name: "index_controls_groups_on_group_id_and_control_id"
  end

  create_table "dependants_parents", id: false, force: :cascade do |t|
    t.bigint "parent_id", null: false
    t.bigint "dependant_id", null: false
  end

  create_table "depends", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.string "url"
    t.string "status"
    t.string "git"
    t.string "branch"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_depends_on_profile_id"
  end

  create_table "descriptions", force: :cascade do |t|
    t.string "label"
    t.string "data"
    t.bigint "control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_id"], name: "index_descriptions_on_control_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.string "version"
    t.string "other_checks"
    t.text "platform"
    t.text "statistics"
    t.datetime "start_time"
    t.text "findings"
    t.bigint "profile_id"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_evaluations_on_profile_id"
  end

  create_table "evaluations_profiles", id: false, force: :cascade do |t|
    t.bigint "evaluation_id", null: false
    t.bigint "profile_id", null: false
  end

  create_table "filter_groups", force: :cascade do |t|
    t.string "name"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "filter_groups_filters", id: false, force: :cascade do |t|
    t.bigint "filter_group_id", null: false
    t.bigint "filter_id", null: false
  end

  create_table "filters", force: :cascade do |t|
    t.string "family"
    t.string "number"
    t.string "sub_fam"
    t.string "sub_num"
    t.string "enhancement"
    t.string "enh_sub_fam"
    t.string "enh_sub_num"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "title"
    t.string "control_id"
    t.text "controls"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_groups_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "maintainer"
    t.string "copyright"
    t.string "copyright_email"
    t.string "license"
    t.string "summary"
    t.string "version"
    t.string "status"
    t.string "sha256"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "parent_profile"
  end

  create_table "results", force: :cascade do |t|
    t.string "status"
    t.string "code_desc"
    t.string "skip_message"
    t.string "resource"
    t.float "run_time"
    t.date "start_time"
    t.string "message"
    t.string "exception"
    t.text "backtrace"
    t.bigint "control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "evaluation_id"
    t.index ["control_id"], name: "index_results_on_control_id"
    t.index ["evaluation_id"], name: "index_results_on_evaluation_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "source_locations", force: :cascade do |t|
    t.string "ref"
    t.integer "line"
    t.bigint "control_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_id"], name: "index_source_locations_on_control_id"
  end

  create_table "supports", force: :cascade do |t|
    t.string "os_family"
    t.string "name"
    t.string "value"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_supports_on_profile_id"
  end

  create_table "tags", force: :cascade do |t|
    t.text "content"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tagger_type", "tagger_id"], name: "index_tags_on_tagger_type_and_tagger_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "type"
    t.string "first_name"
    t.string "last_name"
    t.string "api_key"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "provider"
    t.string "uid"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "xccdfs", force: :cascade do |t|
    t.string "benchmark_title"
    t.string "benchmark_id"
    t.string "benchmark_description"
    t.string "benchmark_version"
    t.string "benchmark_status"
    t.datetime "benchmark_status_date"
    t.string "benchmark_notice"
    t.string "benchmark_notice_id"
    t.string "benchmark_plaintext"
    t.string "benchmark_plaintext_id"
    t.string "reference_href"
    t.string "reference_dc_source"
    t.string "reference_dc_publisher"
    t.string "reference_dc_title"
    t.string "reference_dc_subject"
    t.string "reference_dc_type"
    t.string "reference_dc_identifier"
    t.string "content_ref_href"
    t.string "content_ref_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "aspects", "profiles"
  add_foreign_key "controls", "profiles"
  add_foreign_key "depends", "profiles"
  add_foreign_key "descriptions", "controls"
  add_foreign_key "evaluations", "profiles"
  add_foreign_key "groups", "profiles"
  add_foreign_key "results", "controls"
  add_foreign_key "results", "evaluations"
  add_foreign_key "source_locations", "controls"
  add_foreign_key "supports", "profiles"
end
