class MoviesController < ApplicationController
  require 'typhoeus'
  require 'json'

  def movie_list(query)
    # returns list of 10 movies whose title matches the search query
    request = Typhoeus.get("http://www.omdbapi.com",
    :params => { :s => query } )
    JSON.parse(request.body)["Search"]
  end

  def movie_detail(movie_id)
    # returns the details of a particular movie from the omdb database
    request = Typhoeus.get("http://www.omdbapi.com",
    :params => { :i => movie_id } )
    JSON.parse(request.body)
  end

  def index

  end

  def create
    # creates movie list from omdb API that match the Users input query from home.html.erb
    # query is the search query string entered by the user
    query = params[:query]
    @movies = movie_list(query)
    # puts "$$$$$$$$$$$$$$$$$ Here is the @movies (from create - used in index): #{@movies}"
    render :index
  end

  def show
    # index.html.erb creates <a> tag links to the show method, passes back the movie_id
    # movie_id is the imdb movie_id of the form: tt0095016
    # show.html.erb displays the details of the movie.
    # TODO: the css layout sometimes breaks because the images have different apect ratios
    #    idea: try percentages instead of fixed pixels
    movie_id = params[:id]
    @movie_info = movie_detail(movie_id)
    # puts "$$$$$$$$$$$$$$$$$$ Here is the @movie_info (from show) #{@movie_info}"
   render :show
  end

end
