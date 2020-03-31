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

ActiveRecord::Schema.define(version: 2020_03_29_155945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "check_groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "disclosure_report_id"
    t.index ["disclosure_report_id"], name: "index_check_groups_on_disclosure_report_id"
  end

  create_table "disclosure_checks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "navigation_stack", default: [], array: true
    t.string "kind"
    t.string "under_age"
    t.string "caution_type"
    t.date "conditional_end_date"
    t.string "conviction_type"
    t.date "known_date"
    t.string "conviction_subtype"
    t.string "conviction_length_type"
    t.integer "conviction_length"
    t.string "compensation_paid"
    t.date "compensation_payment_date"
    t.string "motoring_endorsement"
    t.date "motoring_disqualification_end_date"
    t.string "motoring_lifetime_ban"
    t.uuid "check_group_id"
    t.string "conviction_bail"
    t.integer "conviction_bail_days"
    t.boolean "approximate_known_date", default: false
    t.boolean "approximate_conditional_end_date", default: false
    t.boolean "approximate_compensation_payment_date", default: false
    t.boolean "approximate_motoring_disqualification_end_date", default: false
    t.string "compensation_payment_over_100"
    t.string "compensation_receipt_sent"
    t.index ["check_group_id"], name: "index_disclosure_checks_on_check_group_id"
    t.index ["status"], name: "index_disclosure_checks_on_status"
  end

  create_table "disclosure_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_disclosure_reports_on_status"
  end

  create_table "participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference", null: false
    t.integer "access_count", default: 0
    t.string "opted_out"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_participants_on_reference", unique: true
  end

  add_foreign_key "check_groups", "disclosure_reports"
  add_foreign_key "disclosure_checks", "check_groups"
end
