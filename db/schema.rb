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

ActiveRecord::Schema.define(version: 2019_06_18_122806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "disclosure_checks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "navigation_stack", default: [], array: true
    t.string "kind"
    t.string "under_age"
    t.string "caution_type"
    t.date "conditional_end_date"
    t.string "condition_complied"
    t.string "is_date_known"
    t.string "conviction_type"
    t.date "known_date"
    t.string "conviction_subtype"
    t.string "conviction_length_type"
    t.integer "conviction_length"
    t.string "compensation_paid"
    t.date "compensation_payment_date"
    t.index ["status"], name: "index_disclosure_checks_on_status"
  end

end
