class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :favourite_movie]
  before_action :get_actors, only: [:new, :create]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :already_favourite_movie, only: :favourite_movie
  before_action :validate_date_range, only: :index

  def index
    @title = 'All Movies'
    @movies = Movie.search_movie params
  end

  def show
    @title = @movie.name
    @reviews = @movie.reviews.includes(:user).latest
    @review = @movie.reviews.build
    @user_movie_rating = @movie.movie_ratings(current_user)
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to movies_path, notice: 'Movie was successfully created. It needs approval of admin to go live' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  def favourite_movie
    if FavouriteMovie.create(movie: @movie, user: current_user)
      flash[:success] = 'This movie has been added to favourite movies'
    else
      flash[:error] = @movie.errors
    end
    respond_to do |format|
     format.html { redirect_to @movie }
    end
  end

  def get_actors
    @all_actors = Actor.all
  end

  private
    def set_movie
      @movie = Movie.find_by_id(params[:id])
      redirect_to movies_path, alert: 'Movie Not found' if @movie.blank?
    end

    def movie_params
      params.require(:movie).permit(:name, :released_date, :description, :duration, :embedded_video, :genre, actor_ids: [], images_attributes: [:id, :image, :_destroy])
    end

    def already_favourite_movie
      if FavouriteMovie.already_favourite?(@movie, current_user)
        flash[:error] = 'Already added to favourite movies'
        redirect_to movie_path(@movie)
      end
    end

    def validate_date_range
      message = valid_date_range(params)
      redirect_to movies_path, alert: message if message
    end

end
