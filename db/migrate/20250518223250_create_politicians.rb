class CreatePoliticians < ActiveRecord::Migration[7.2]
  def change
    create_table :politicians do |t|
      t.string :full_name
      t.string :position
      t.string :party
      t.string :region
      t.string :about
      t.string :image_url
      t.integer :upvotes
      t.integer :downvotes
      t.integer :total_votes
      t.string :slug

      t.timestamps
    end
  end
end
