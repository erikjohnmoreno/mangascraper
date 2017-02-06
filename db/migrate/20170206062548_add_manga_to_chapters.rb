class AddMangaToChapters < ActiveRecord::Migration[5.0]
  def change
    add_reference :chapters, :manga, foreign_key: true
  end
end
