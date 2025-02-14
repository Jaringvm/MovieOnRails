class PagesController < ApplicationController

  def home
  end

  def overview
  end

  def upload

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
