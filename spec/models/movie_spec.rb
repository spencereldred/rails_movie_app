require 'spec_helper'

describe Movie do
  before { @movie = Movie.create(movie_id: 'tt0114694', title: "Tommy Boy", rating: 5, review: "Best Movie ever!") }

  subject { @movie }

  it { should respond_to(:movie_id) }
  it { should respond_to(:title) }
  it { should respond_to(:rating) }
  it { should respond_to(:review) }



end




describe Movie do
  it 'is invalid without a rating' do
    movie = Movie.new
    movie.should_not be_valid
  end
end

describe Movie do
  it 'is valid with a rating and review' do
    movie = Movie.new(rating: 3, review: "it is OK")
  end
end
