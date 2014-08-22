class AddColumnToProgramsDate < ActiveRecord::Migration
  def change
    add_column :programs, :day, :date
  end
end
