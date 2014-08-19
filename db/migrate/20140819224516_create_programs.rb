class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.time :scheduled_time

      t.timestamps
    end
  end
end
