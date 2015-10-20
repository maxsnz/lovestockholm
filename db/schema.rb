# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150215160126) do

  create_table "players", force: true do |t|
    t.string   "uid",        null: false
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["uid"], name: "index_players_on_uid", unique: true, using: :btree

  create_table "questions", force: true do |t|
    t.string   "question",                   null: false
    t.text     "options",                    null: false
    t.boolean  "brand",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions_results", id: false, force: true do |t|
    t.integer "question_id", null: false
    t.integer "result_id",   null: false
  end

  add_index "questions_results", ["question_id", "result_id"], name: "index_questions_results_on_question_id_and_result_id", unique: true, using: :btree

  create_table "results", force: true do |t|
    t.integer  "player_id",                                         null: false
    t.string   "state",                                             null: false
    t.decimal  "seconds",    precision: 12, scale: 2, default: 0.0, null: false
    t.decimal  "start",      precision: 12, scale: 2,               null: false
    t.integer  "n",                                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["player_id"], name: "index_results_on_player_id", using: :btree
  add_index "results", ["state", "n", "seconds"], name: "index_results_on_state_and_n_and_seconds", using: :btree

  create_table "tokens", force: true do |t|
    t.string   "uid",        null: false
    t.string   "token",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokens", ["uid", "token"], name: "index_tokens_on_uid_and_token", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "login",      null: false
    t.string   "email",      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "userpic"
    t.text     "profile"
    t.string   "state",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["login"], name: "index_users_on_login", using: :btree

  create_table "weeks", force: true do |t|
    t.integer  "n",          null: false
    t.date     "start",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weeks", ["n"], name: "index_weeks_on_n", unique: true, using: :btree
  add_index "weeks", ["start"], name: "index_weeks_on_start", using: :btree

end
