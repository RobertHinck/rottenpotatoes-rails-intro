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
    
    #define all_ratings for the checkboxes
    @all_ratings =  Movie.possible_ratings
    
    #store everything in session
    if params[:sort]
      session[:sort] = params[:sort]
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    #check params for sorting by title
    if params[:sort] == 'title'
      @title_header = 'hilite'
      @movies = Movie.order(:title)
      
    #check params for sorting by date
    elsif params[:sort] == 'date'
      @release_date_header ='hilite'
      @movies = Movie.order(:release_date)
      
    #if not in params check session and redirect if necessary
    elsif session[:sort]
      @title_header = 'hilite'
      flash.keep
      redirect_to movies_path(:sort => session[:sort])
      return
      
    #otherwise show all
    else
      @movies = Movie.all
    end

    #check params for ratings filter
    if !params[:ratings].nil?
      @movies = @movies.where(rating: params[:ratings].keys)
      
    # if not in params check session and redirect if necessary
    elsif !session[:ratings].nil?
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
      return
    end
    

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
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

end
