class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string     :movie_id
      t.string     :title
      t.integer   :rating
      t.string     :review

      t.timestamps
    end
  end
end
