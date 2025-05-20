class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.references :politician, null: false, foreign_key: true
      t.string :ip_address
      t.string :vote_type

      t.timestamps
    end
  end
end
