class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :overview
      t.string :release
      t.string :poster
      t.string :backdrop
      t.float :rating
      t.integer :popularity
      t.string :genre
      t.integer :original_id

      t.timestamps
    end
  end
end
