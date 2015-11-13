class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @sort_by = params[:sort_by]
    if @sort_by == "title" || @sort_by == "release_date"
      @movies = Movie.order @sort_by
    else
      @movies = Movie.all
    end
    
    @selected_ratings = params[:ratings] || {}
    @all_ratings.each { |rating| @selected_ratings[rating] = 1 } if @selected_ratings.empty?
    @movies =  @movies.where rating: @selected_ratings.keys

  end

  def new
    # default: render 'new' template
    @all_ratings = Movie.all_ratings
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @all_ratings = Movie.all_ratings
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

=begin
  def sort
    flash[:sort] = "movie-title"@movies = Movies.all.sort_by { |movie| movie.send(params[:by].to_sym) }
  end
=end
end
