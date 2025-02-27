class PagesController < ApplicationController

  def home
  end

  def overview
  end

  def upload
    redirect_to new_upload_path
  end

  def about
  end

  def review
  end
end
