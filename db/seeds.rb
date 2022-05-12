# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if User.count.zero?
  puts '-- added user'
  User.create(login: 'sindan', email: 'sindan@ml.kanazawa-u.ac.jp', password: 'sindan@ml.kanazawa-u.ac.jp')
end
