class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.integer :reports_count, default: 0
      t.boolean :archived, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
