# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# loras = [
#   {
#     name: 'flux-schnell',
#     value: 'black-forest-labs/flux-schnell',
#     cost_credits: 1
#   },
#   {
#     name: 'flux-dev',
#     value: 'black-forest-labs/flux-dev',
#     cost_credits: 10
#   },
#   {
#     name: 'flux-pro',
#     value: 'black-forest-labs/flux-pro',
#     cost_credits: 20
#   },
#   {
#     name: 'flux-dev-lora',
#     value: 'lucataco/flux-dev-lora',
#     cost_credits: 10
#   },
#   {
#     name: 'flux-albert-einstein',
#     value: 'pwntus/flux-albert-einstein',
#     cost_credits: 10
#   },
#   {
#     name: 'flux-dreamscape',
#     value: 'bingbangboom-lab/flux-dreamscape',
#     cost_credits: 10
#   },
#   {
#     name: 'flux-dev-realism',
#     value: 'xlabs-ai/flux-dev-realism',
#     cost_credits: 10
#   },
#   {
#     name: 'disposable-camera',
#     value: 'levelsio/disposable-camera',
#     cost_credits: 20
#   },
#   {
#     name: 'flux-monkey-island',
#     value: 'andreasjansson/flux-monkey-island',
#     cost_credits: 20
#   },
#   {
#     name: 'pen_lettering_flux_lora',
#     value: 'agusdor/pen_lettering_flux_lora',
#     cost_credits: 20
#   },
#   {
#     name: 'flux-80s-cyberpunk',
#     value: 'fofr/flux-80s-cyberpunk',
#     cost_credits: 10
#   },
#   {
#     name: 'flux-watercolor',
#     value: 'lucataco/flux-watercolor',
#     cost_credits: 10,
#     example_pics: %w(
# https://replicate.delivery/pbxt/89kikrVNWfxve0Oy3YjWHqpXri9FeejOfDbP1Kdhcq7uPkqVC/ComfyUI_00001_.webp
# )
#   },
#   {
#     name: 'sticker-maker',
#     value: 'fofr/sticker-maker',
#     cost_credits: 2,
#     example_pics: %w(
#       https://replicate.delivery/pbxt/89kikrVNWfxve0Oy3YjWHqpXri9FeejOfDbP1Kdhcq7uPkqVC/ComfyUI_00001_.webp
#       https://replicate.delivery/pbxt/o6Y0CfYIud3uXKVXm41rTK4jV87Hpe5UFX3wHN5yppC1ckZSA/ComfyUI_00001_.png
#     )
#   },
# ]

loras = [
  {
    name: 'hyper-flux-8step',
    value: 'lucataco/hyper-flux-8step',
    cost_credits: 10
  },
  {
    name: 'flux-childbook-illustration',
    value: 'samsa-ai/flux-childbook-illustration',
    cost_credits: 10
  },
  {
    name: 'sdxl-lightning-4step',
    value: 'bytedance/sdxl-lightning-4step',
    cost_credits: 2
  },
  {
    name: 'consistent-character',
    value: 'fofr/consistent-character',
    cost_credits: 10
  },
  {
    name: 'pulid-base',
    value: 'fofr/pulid-base',
    cost_credits: 5
  },
  # {
  #   name: 'face-to-many',
  #   value: 'fofr/face-to-many',
  #   cost_credits: 5
  # },
  {
    name: 'style-transfer',
    value: 'fofr/style-transfer',
    cost_credits: 2
  },
  {
    name: 'become-image',
    value: 'fofr/become-image',
    cost_credits: 4
  },
  {
    name: 'face-to-sticker',
    value: 'fofr/face-to-sticker',
    cost_credits: 10
  },
  {
    name: 'flux-mjv3',
    value: 'fofr/flux-mjv3',
    cost_credits: 20
  },
  {
    name: 'flux-mona-lisa',
    value: 'fofr/flux-mona-lisa',
    cost_credits: 15
  },
  {
    name: 'aura-flow',
    value: 'fofr/aura-flow',
    cost_credits: 20
  },
  {
    name: 'kolors',
    value: 'fofr/kolors',
    cost_credits: 20
  },
]

loras.each do |lora|
  Lora.create(lora)
end