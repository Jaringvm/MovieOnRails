class MoviesController < ApplicationController
  # Queries all the movies sorted by average rating.
  # Gives the option to search for movies based on the actors.
  # @param :page [String] Holds the current page number.
  # @param 'search' [String] Input for searching for a specific actor.
  def index
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    @per_page = 5

    # Retrieves all movies ordered by rating.
    # (optional) search by actor if search param is given.
    @movies_with_ratings = Movie.left_joins(:reviews)
                                .select('movies.*, ROUND(AVG(reviews.rating), 1) as total_rating')
                                .group('movies.id')
                                .order('total_rating DESC')
                                .yield_self do |query|
                                  if params["search"].present?
                                    query.joins(:actors).where("actors.name ILIKE ?", "%#{params["search"]}%")
                                  else
                                    query
                                  end
                                end

    @total_movies = @movies_with_ratings.length || 0
    @total_pages = (@total_movies / @per_page).ceil

    @movies = @movies_with_ratings.limit(@per_page).offset((@page.to_i - 1) * @per_page)
  end
end
