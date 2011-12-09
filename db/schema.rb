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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111209032543) do

  create_table "meeting_people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "rsvp"
    t.string   "presence"
    t.integer  "meeting_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_url"
  end

  create_table "meeting_tasks", :force => true do |t|
    t.string   "description"
    t.integer  "topic_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meeting_topics", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "meeting_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetings", :force => true do |t|
    t.string   "subject"
    t.integer  "creator_id"
    t.datetime "date"
    t.string   "state"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mail_list"
    t.text     "invitation_text"
    t.string   "management_url"
  end

end
