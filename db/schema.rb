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

ActiveRecord::Schema[8.0].define(version: 2025_02_27_124135) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "actors", force: :cascade do |t|
    t.string "name"
  end

  create_table "actors_movies", id: false, force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "actor_id", null: false
    t.index ["actor_id", "movie_id"], name: "index_actors_movies_on_actor_id_and_movie_id", unique: true
    t.index ["movie_id", "actor_id"], name: "index_actors_movies_on_movie_id_and_actor_id", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
  end

  create_table "locations_movies", id: false, force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "location_id", null: false
    t.index ["location_id", "movie_id"], name: "index_locations_movies_on_location_id_and_movie_id", unique: true
    t.index ["movie_id", "location_id"], name: "index_locations_movies_on_movie_id_and_location_id", unique: true
  end

  create_table "movies", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "year"
    t.string "director"
    t.index ["name"], name: "index_movies_on_name", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.string "name"
    t.integer "rating"
    t.text "content"
    t.bigint "movie_id", null: false
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["name"], name: "index_reviews_on_name", unique: true
  end

  add_foreign_key "reviews", "movies"
end
