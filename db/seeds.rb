# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

#db/seeds.rb
require "json"

json_path = Rails.root.join("db", "seeds", "politicians.json")
politicians = JSON.parse(File.read(json_path))

puts "🌱  Seeding #{politicians.size} politicians …"

politicians.each do |attrs|
  # If you want to re-run seeds without duplicates, find by slug first
  record = Politician.find_or_initialize_by(slug: attrs["slug"])

  # assign_attributes lets us update existing records, too
  record.assign_attributes(
    full_name:   attrs["full_name"],
    position:    attrs["position"],
    party:       attrs["party"],
    region:      attrs["region"],
    about:       attrs["about"],
    image_url:   attrs["image_url"],
    upvotes:     attrs["upvotes"],
    downvotes:   attrs["downvotes"],
    total_votes: attrs["total_votes"]
  )

  record.save!
end

puts "✅  Done – #{Politician.count} total politicians in the DB."


AdminUser.create!(
  name: "Admin User",
  email: "admin@ratesa.com",
  password: "password123",
  password_confirmation: "password123"
)

