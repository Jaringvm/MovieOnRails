class PagesController < ApplicationController
  $file = nil
  def home
  end

  def overview
  end

  def upload

  end

  def import_file
    $file = params[:file]
    puts $file
    redirect_to upload_path
  end

  def about
  end

  def review
  end
end
