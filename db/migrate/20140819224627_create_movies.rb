class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.integer :duration
      t.integer :year
      t.text :description
      t.integer :rating

      t.timestamps
    end
  end
end
