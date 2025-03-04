class UploadsController < ApplicationController
  def new
    if params[:submitted] == "true"
      if params[:dataType] == "Movies"
        @arr = {
          "movies": (Movie.column_names - %w[id]).map { |header| [header, header] }.to_h,
          "locations": (Location.column_names - %w[id]).map { |header| [header, header] }.to_h,
          "actors": (Actor.column_names - %w[id]).map { |header| [header, header] }.to_h,
        }
      elsif params[:dataType] == "Reviews"
        @arr = {
          "reviews": (Review.column_names - %w[id]).map { |header| [header, header] }.to_h,
          "users": (User.column_names - %w[id]).map { |header| [header, header] }.to_h,
        }
      else
        flash[:error] = "Please pick between the provided data types."
        redirect_to new_upload_path
      end

      @uploaded_headers = params[:file_headers].is_a?(Array) ? params[:file_headers] : params[:file_headers][0].split(";")
    end
  end

  def create
    if params["reviews"]
      reviews = params["reviews"]
      users = params["users"]

      $csv.each do |row|
        movie = Movie.find_or_create_by!(name: row[reviews["movie_id"]])
        user = User.find_or_create_by!(name: row[users["name"]])

        review = Review.create!(
          rating: row[reviews["rating"]],
          content: row[reviews["content"]],
          movie: movie,
          user: user  # Fix: Assign user directly
        )
      end

    elsif params["movies"]
      movies = params["movies"]
      locations = params["locations"]
      actors = params["actors"]

      $csv.each do |row|
        actor = Actor.find_or_create_by!(name: row[actors["name"]])
        location = Location.find_or_create_by!(city: row[locations["city"]], country: row[locations["country"]])

        movie = Movie.find_or_create_by!(name: row[movies["name"]]) do |m|
          m.description = row[movies["description"]]
          m.year = row[movies["year"]]
          m.director = row[movies["director"]]
        end

        movie.actors << actor unless movie.actors.include?(actor)
        movie.locations << location unless movie.locations.include?(location)
      end
    else
      flash[:error] = "Missing required fields"
      render :new, status: :unprocessable_entity
    end

    flash[:notice] = "Successfully uploaded new data."
    redirect_to root_path
  end

  def import_file
    require 'csv'
    if params[:file] && File.extname(params[:file].path) == '.csv'
      file = params[:file].path

      $csv = CSV.read(file, headers: true)
      headers = $csv.headers
      data_type = params[:data_type]
      redirect_to new_upload_path(submitted: true, file_headers: headers, dataType: data_type)
    else
      flash[:error] = "Only .csv files are allowed!"
      redirect_to new_upload_path
    end
  end
end
