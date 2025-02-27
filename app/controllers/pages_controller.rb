class PagesController < ApplicationController

  def home
  end

  def overview
    @movie_columns = Movie.column_names - %W[id]
    @movies = Movie.all
  end

  def upload
    redirect_to new_upload_path
  end

  def about
  end

  def review
  end
end
