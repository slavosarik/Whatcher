class AddReferencesToMovieGenres < ActiveRecord::Migration
  def change
    add_column :movie_genres, :movie_id, :integer, null: false
    add_column :movie_genres, :genre_id, :integer, null: false
  end
end
