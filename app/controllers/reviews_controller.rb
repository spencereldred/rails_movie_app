class ReviewsController < ApplicationController
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


  def get_movie_reviews()
    # accesses movies table and returns array of hashes
    # hash:  [ { title => [ number of reviews, movie id]}, ... ]
    # title := array of titles
    title = Movie.all(:select => "DISTINCT(title)")
    # movie_id := array of movie_ids
    movie_id = Movie.all(:select => "DISTINCT(movie_id)")
    i = 0
    results =[]
    # crates array of hashes
    while i < title.length
      results.push( { "'#{title[i][:title]}'" => [Movie.count(:conditions => "title = '#{title[i][:title]}'"), "#{movie_id[i][:movie_id]}" ] } )
      i += 1
    end
    # sends variable values to the console
    # puts "&&&&&&&&&& The DISTINCT titles are (from index): #{title}"
    # puts "&&&&&&&&&& The DISTINCT movie_id are (from index): #{movie_id}"
    # puts "#{title[0][:title]}"
    # puts "#{movie_id[0][:movie_id]}"
    # puts "#{results}"
    results
  end

  def average_rating(all_reviews)
    # calculates the average rating for all the reviews of a particular movie
    i = 0
    sum = 0.0
    while i < all_reviews.count
      puts all_reviews[i][:rating]
      sum += all_reviews[i][:rating]
      i += 1
    end
    average = (sum / all_reviews.count).round(1)
    # puts "@@@@@@@@@The average rating is: #{average}"
    average
  end

  def index
    # displays a list of reviewed movies
    @reviews = get_movie_reviews()

  end

  def show
    # displays most recent 5 reviews of a particular movie
    # displays average rating for that movie
    # TODO: calculate avgerage rating using SQL rather than a ruby method
    @movie_reviews = Movie.find_by_sql("SELECT * FROM movies WHERE movie_id = '#{params[:id]}' ORDER BY created_at desc LIMIT 5;")
    # puts "&&&&&&& Movie reviews (from show) #{@movie_reviews}."
    # puts "&&&&&&& params[:id] (from show) #{params[:id]}"
    @all_reviews = Movie.find_by_sql("SELECT * FROM movies WHERE movie_id = '#{params[:id]}';")
    @average_rating = average_rating(@all_reviews)
    # puts "&&&&&&& @average_rating: #{@average_rating}"
  end

  def create
    # takes data from the "add a movie review" page and creates a Movie db entry
    # renders the index page with the updated Movie db
    movie_id = params[:movie_id]
    title = params[:title]
    rating = params[:rating]
    review = params[:review]
    Movie.create(movie_id: movie_id, title: title, rating: rating, review: review)
    @reviews = get_movie_reviews()
    render :index
  end

  def new
    # gets the new.html.erb ready with @movie_id and @title variables
    # User does not enter these values, they are protected from the user
    # User only enters rating and review.
    @movie_id = params[:id]
    movie = Movie.find_by_movie_id(@movie_id)
    if movie == nil
      # if adding a review to a movie not in the database
      movie_info = movie_detail(@movie_id)
      @title = movie_info["Title"]
      # puts "$$$$$$$$$$ no movie in the db"
    else
      # movie exists in the database load instance variables from database
      @title = movie.title
    end
    # puts "&&&&&&&&&& Movie title (from new): #{@title}"
    # puts "&&&&&&&&&& Movie ID (from new): #{@movie_id}"
  end
end
