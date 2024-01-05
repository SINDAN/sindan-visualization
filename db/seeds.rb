# This file should contain all the record creation needed to seed the database with its default values.
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
# Example:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if User.count.zero?
  puts '-- added user'
  User.create(login: 'sindan', email: 'sindan@ml.kanazawa-u.ac.jp', password: 'sindan@ml.kanazawa-u.ac.jp')
end
