class Change < ActiveRecord::Migration
  def change
    change_column :movies, :duration, 'integer USING CAST(duration AS integer)'
  end
end