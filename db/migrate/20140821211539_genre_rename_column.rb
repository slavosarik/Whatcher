class GenreRenameColumn < ActiveRecord::Migration
  def change
    rename_column :genres, :type, :genre_type
  end
end
