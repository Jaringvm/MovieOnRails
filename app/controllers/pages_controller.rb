class PagesController < ApplicationController
  def home
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    @per_page = 5

    @movies_with_ratings = Movie.left_joins(:reviews)
                                .select('movies.*, ROUND(AVG(reviews.rating), 1) as total_rating')
                                .group('movies.id')
                                .order('total_rating DESC')

    @total_movies = @movies_with_ratings.length || 0
    @total_pages = (@total_movies.to_f / @per_page).ceil

    @movies = @movies_with_ratings.limit(@per_page).offset((@page.to_i - 1) * @per_page)
  end

  def upload
    redirect_to new_upload_path
  end
end
