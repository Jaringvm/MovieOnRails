class UploadsController < ApplicationController
  # Parses the database structure to a hashes with column names as keys and empty values.
  # @param [Boolean] :submitted Signals when the user imports a csv file.
  # @param [String] :dataType Shows if the user is uploading movies or reviews.
  # @param [Array] :file_headers Column headers extracted from imported csv file.
  def new
    # Ensures a file was uploaded.
    if params[:submitted] == "true"
      if params[:dataType] == "Movies"
        # Parses the database structure into a nested hash.
        @db_structure = {
          "movies": (Movie.column_names - %w[id]).map { |header| [header, header] }.to_h,
          "locations": (Location.column_names - %w[id]).map { |header| [header, header] }.to_h,
          "actors": (Actor.column_names - %w[id]).map { |header| [header, header] }.to_h,
        }
      elsif params[:dataType] == "Reviews"
        # Parses the database structure into a nested hash.
        @db_structure = {
          "reviews": (Review.column_names - %w[id]).map { |header| [header, header] }.to_h,
          "users": (User.column_names - %w[id]).map { |header| [header, header] }.to_h,
        }
      else
        flash[:error] = "Please pick between the provided data types."
        redirect_to new_upload_path
      end
      # Splits the uploaded_headers if the headers are split by ';' instead of ','.
      @uploaded_headers = params[:file_headers].is_a?(Array) ? params[:file_headers] : params[:file_headers][0].split(";")
    end
  end

  # Inserts the uploaded csv file to the database based on the by the user mapped headers.
  # @param [Hash{String => String}] 'reviews' Holds the mapped review headers.
  # @param [Hash{String => String}] 'users' Holds the mapped user headers.
  # @param [Hash{String => String}] 'movies' Holds the mapped movie headers.
  # @param [Hash{String => String}] 'locations' Holds the mapped location headers.
  # @param [Hash{String => String}] 'actors' Holds the mapped actor headers.
  def create
    if params["reviews"]
      reviews = params["reviews"]
      users = params["users"]

      $csv.each do |row|
        movie = Movie.find_or_create_by!(name: row[reviews["movie_id"]])
        user = User.find_or_create_by!(name: row[users["name"]])

        Review.create!(
          rating: row[reviews["rating"]],
          content: row[reviews["content"]],
          movie: movie,
          user: user
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

        # Prevents duplicate relations.
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

  # Checks if the file is the correct extension and reads the headers of the csv file.
  # @param [File] :file By the user uploaded file.
  # @param [String] :dataType shows if the user is uploading movies or reviews.
  def import_file
    require 'csv'

    # Checks if the imported file is the correct extension
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
