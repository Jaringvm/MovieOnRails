class UploadsController < ApplicationController
  def new
    if params[:submitted] == "true"

      @movie_headers = Movie.column_names - %W[id]
      @location_headers = Location.column_names - %W[id]
      @actor_headers = Actor.column_names - %W[id]

      @movie_headers.map { |header| [header, header] }.to_h
      @location_headers.map { |header| [header, header] }.to_h
      @actor_headers.map { |header| [header, header] }.to_h

      @arr = {
        "movies": @movie_headers,
        "locations": @location_headers,
        "actors": @actor_headers
      }

      if params[:file_headers].length == 1
        @uploaded_headers = params[:file_headers][0].split(";")
      else
        @uploaded_headers = params[:file_headers]
      end
    end
  end

  def create
    puts params
    movies = params["movies"]
    locations = params["locations"]
    actors = params["actors"]

    $csv.each do |row|
      actor = Actor.find_or_create_by!(name: row[actors["name"]])
      location = Location.find_or_create_by!(name: row[locations["name"]])

      movie_id = Movie.upsert(
        {
          name: row[movies["name"]],
          description: row[movies["description"]],
          year: row[movies["year"]],
          director: row[movies["director"]]
        },
        unique_by: :name
      )

      movie = Movie.find_by(id: movie_id[0]["id"])

      movie.actors << actor unless movie.actors.include?(actor)
      movie.locations << location unless movie.locations.include?(location)
    end
  end

  def import_file
    require 'csv'
    if params[:file] and File.extname(params[:file].path) == '.csv'
      file = params[:file].path

      $csv = CSV.read(file, headers: true)
      headers = $csv.headers
      puts headers
      redirect_to new_upload_path(submitted: true, file_headers: headers)
    else
      flash[:error] = "Only files with .csv extension are allowed!"
      redirect_to new_upload_path
    end
  end


end
