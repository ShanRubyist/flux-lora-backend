# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

loras = [
  {
    name: 'flux-schnell',
    value: 'black-forest-labs/flux-schnell',
    cost_credits: 1
  },
  {
    name: 'flux-dev',
    value: 'black-forest-labs/flux-dev',
    cost_credits: 10
  },
  {
    name: 'flux-pro',
    value: 'black-forest-labs/flux-pro',
    cost_credits: 20
  }
]

loras.each do |lora|
  Lora.create(name: lora.fetch(:name), value: lora.fetch(:value), cost_credits: lora.fetch(:cost_credits))
end