class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

=begin

  def index_Adail
    need_redirect = false
    if params[:sort_by] =~ /\Atitle\z|\Arelease_date\z/
      @sort_by = params[:sort_by]
      session[:sort_by] = @sort_by
    else
      @sort_by = session[:sort_by]
      need_redirect = true
    end
    @movies = Movie.order @sort_by
    if params[:ratings]
      if params[:ratings].is_a? Hash
        @ratings = params[:ratings].keys
      else
        @ratings = params[:ratings]
      end
      session[:ratings] = @ratings
    else
      @ratings = session[:ratings] || Movie.ratings
      need_redirect = true
    end
    if need_redirect && !session[:redirected]
      session[:redirected] = true
      flash.keep
      ratings_hash = {}
      @ratings.each { |r| ratings_hash[r] = 1 }
      redirect_to movies_path sort_by: @sort_by, ratings: ratings_hash
    else
      session.delete :redirected
      @movies = @movies.where rating: @ratings
      @all_ratings = Movie.ratings
    end
  end
=end


  def index
    @all_ratings = Movie.all_ratings
    @sort_by = params[:sort_by]
    if %w(title release_date).include? @sort_by
      @movies = Movie.order @sort_by
      session[:sort_by] = @sort_by
    elsif %w(title release_date).include? session[:sort_by]
      @sort_by = session[:sort_by]
    end
    @movies = Movie.order @sort_by
    
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    @all_ratings.each { |rating| @selected_ratings[rating] = 1 } if @selected_ratings.empty?
    @movies =  @movies.where rating: @selected_ratings.keys
    session[:ratings] = @selected_ratings
    
    if params[:ratings].nil?
      flash.keep
      redirect_to movies_path sort_by: session[:sort_by], ratings: session[:ratings]
    end
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
