class UploadsController < ApplicationController
  def new
    if params[:submitted] == "true"
      if params[:dataType] == "Movies"
        @arr = {
          "movies": (Movie.column_names - %W[id]).map { |header| [header, header] }.to_h,
          "locations": (Location.column_names - %W[id]).map { |header| [header, header] }.to_h,
          "actors": (Actor.column_names - %W[id]).map { |header| [header, header] }.to_h,
        }
      elsif params[:dataType] == "Reviews"
        @arr = {
          "reviews": (Review.column_names - %W[id]).map { |header| [header, header] }.to_h
        }
      else
        flash[:error] = "Please pick between the provided data types."
        redirect_to new_upload_path
      end

      if params[:file_headers].length == 1
        @uploaded_headers = params[:file_headers][0].split(";")
      else
        @uploaded_headers = params[:file_headers]
      end
    end
  end

  def create
    if params["reviews"]
      reviews = params["reviews"]
      $csv.each do |row|
        movie = Movie.find_or_create_by!(name: row[reviews["name"]])
        puts "the data ", movie
        puts "the params ", params
        review_id = Review.upsert(
          {
            name: row[reviews["name"]],
            rating: row[reviews["rating"]],
            content: row[reviews["content"]],
            movie_id: movie["id"]
          },
          unique_by: :name
        )
      end

    elsif params["movies"]
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
    else
      flash["error"] = "missing required fields"
      render :new, status: 500
    end
    flash[:notice] = "Successfully uploaded new movie data."
    redirect_to root_path
  end

  def import_file
    require 'csv'
    if params[:file] and File.extname(params[:file].path) == '.csv'
      file = params[:file].path

      $csv = CSV.read(file, headers: true)
      headers = $csv.headers
      data_type = params[:data_type]
      redirect_to new_upload_path(submitted: true, file_headers: headers, dataType: data_type)
    else
      flash[:error] = "Only files with .csv extension are allowed!"
      redirect_to new_upload_path
    end
  end
end
