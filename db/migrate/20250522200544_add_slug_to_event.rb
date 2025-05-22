class AddSlugToEvent < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :slug, :string
  end
end
