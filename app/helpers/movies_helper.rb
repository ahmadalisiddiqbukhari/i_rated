module MoviesHelper

  def fetch_image(image, size= :med)
    image.image.url(size) unless image.nil?
  end

  def collection_for_movie_genre
    Movie::GENRE
  end

  def star_class(movie, current_user)
    movie.movie_ratings(current_user) ? 'rating-star' : 'user-star'
  end

  def rating_div
    content_tag(:div, "", id: star_class(@movie, current_user), data: {movie_id: @movie.id, overall_rating: @movie.average_rating, movie_ratings: @user_movie_rating.try(:score), rating_id: @user_movie_rating.try(:id)})
  end

end
