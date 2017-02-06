class CreateMangas < ActiveRecord::Migration[5.0]
  def change
    create_table :mangas do |t|
      t.string :title
      t.string :url
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
