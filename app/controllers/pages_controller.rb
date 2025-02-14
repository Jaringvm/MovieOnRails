class PagesController < ApplicationController

  def home
  end

  def overview
  end

  def upload
    if params[:submitted] == "true"

      @movie_headers = Movie.column_names - %W[id]
      @location_headers = Location.column_names - %W[id]
      @actor_headers = Actor.column_names - %W[id]

      @movie_headers.map { |header| [header, header] }.to_h
      @location_headers.map { |header| [header, header] }.to_h
      @actor_headers.map { |header| [header, header] }.to_h
      @uploaded_headers = params[:file_headers]
    end
  end

  def mapped_file

  end
  def import_file
    require 'csv'
    if File.extname(params[:file].path) == '.csv'
      file = params[:file].path

      headers = CSV.read(file, headers: true).headers
      puts headers
      redirect_to upload_path(submitted: true, file_headers: headers)
    else
      flash[:error] = "Only files with .csv extension are allowed!"
      redirect_to upload_path
    end
  end

  def about
  end

  def review
  end
end
