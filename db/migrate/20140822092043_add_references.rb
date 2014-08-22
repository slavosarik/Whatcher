class AddReferences < ActiveRecord::Migration
  def change
    add_column :programs, :channel_id, :integer, null: false
    add_column :programs, :movie_id, :integer, null: false
  end
end
