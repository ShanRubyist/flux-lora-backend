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
  },
  {
    name: 'flux-dev-lora',
    value: 'lucataco/flux-dev-lora',
    cost_credits: 10
  },
  {
    name: 'flux-albert-einstein',
    value: 'pwntus/flux-albert-einstein',
    cost_credits: 10
  },
  {
    name: 'flux-dreamscape',
    value: 'bingbangboom-lab/flux-dreamscape',
    cost_credits: 10
  },
  {
    name: 'flux-dev-realism',
    value: 'xlabs-ai/flux-dev-realism',
    cost_credits: 10
  },
  {
    name: 'disposable-camera',
    value: 'levelsio/disposable-camera',
    cost_credits: 20
  },
  {
    name: 'flux-monkey-island',
    value: 'andreasjansson/flux-monkey-island',
    cost_credits: 20
  },
  {
    name: 'pen_lettering_flux_lora',
    value: 'agusdor/pen_lettering_flux_lora',
    cost_credits: 20
  },
  {
    name: 'flux-80s-cyberpunk',
    value: 'fofr/flux-80s-cyberpunk',
    cost_credits: 10
  },
  {
    name: 'flux-watercolor',
    value: 'lucataco/flux-watercolor',
    cost_credits: 10
  },
  {
    name: 'sticker-maker',
    value: 'fofr/sticker-maker',
    cost_credits: 2
  },
]

loras.each do |lora|
  Lora.create(name: lora.fetch(:name), value: lora.fetch(:value), cost_credits: lora.fetch(:cost_credits))
end