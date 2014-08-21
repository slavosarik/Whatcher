class ProgramChangeColumnNames < ActiveRecord::Migration
  def change
    rename_column :programs, :scheduled_time, :scheduled_time_start
    add_column :programs, :scheduled_time_end, :integer, null: false
  end
end
