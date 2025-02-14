class PagesController < ApplicationController
  $file = nil
  $columns = []
  def home

  end

  def upload

    puts "hey"
    if $file
      @data_struct = {}
      @data_struct["Movies"] = Movie.column_names - %W[id]
      @data_struct["Locations"] = Location.column_names - %W[id]
      @data_struct["Actors"] = Actor.column_names - %W[id]
    end

  end

  def mapping
    require 'csv'
    $file = params[:file]
    file = CSV.read(params[:file].path, headers: true)
    $columns = file[0]


    redirect_to upload_path
  end

  def sort
    puts params
    params.each do |key, value|
      puts "key: "
      p key
    end

    redirect_to upload_path
  end
end
