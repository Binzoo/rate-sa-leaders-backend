class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.integer :upvote
      t.integer :downvote
      t.integer :total

      t.timestamps
    end
  end
end
