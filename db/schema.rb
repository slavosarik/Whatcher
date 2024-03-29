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

ActiveRecord::Schema.define(version: 20140826150407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", force: true do |t|
    t.string   "genre_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movie_genres", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id",   null: false
    t.integer  "genre_id",   null: false
  end

  create_table "movies", force: true do |t|
    t.string   "name"
    t.integer  "duration"
    t.integer  "year"
    t.text     "description"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", force: true do |t|
    t.time     "scheduled_time_start"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "scheduled_time_end"
    t.integer  "channel_id",           null: false
    t.integer  "movie_id",             null: false
    t.date     "day"
  end

end
