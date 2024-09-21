# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require_relative '../lib/scraper'
require 'json'

loras = JSON.parse(File.read("lib/output.json"))

def create_new_showcase(lora, prompt, image)
  lora_showcase = lora.showcases.find_by(prompt: prompt)

  if lora_showcase.nil? || !lora_showcase.image.attached?
    showcase = lora.showcases.create(prompt: prompt, output: image)
    require 'open-uri'
    begin
      showcase.image.attach(io: URI.open(image), filename: URI(image).path.split('/').last) unless image.empty?
    rescue OpenURI::HTTPError => e
      puts "警告：无法下载图片 #{image}. 错误: #{e.message}"
    rescue StandardError => e
      puts "警告：处理图片 #{image} 时出错. 错误: #{e.message}"
    end
  end
end

loras.each do |i|
  # 创建或更新 lora
  lora = Lora.find_by(value: i.fetch('model_value'))
  if lora
    lora.update(
      runs: i.fetch('runs').gsub(/(\d+(?:\.\d+)?)\s*([KkMmBb])/) { |match|
        num = $1.to_f
        case $2.downcase
        when 'k'
          (num * 1000).to_i
        when 'm'
          (num * 1000000).to_i
        when 'b'
          (num * 1000000000).to_i
        end
      },
      # description: i.fetch('description'),
      cost_credits: (i.fetch('cost_credits').to_f / 0.003).ceil
    )
  else
    lora = Lora.create(
      name: i.fetch('model'),
      value: i.fetch('model_value'),
      cost_credits: (i.fetch('cost_credits').to_f / 0.003).ceil,
      runs: i.fetch('runs').gsub(/(\d+(?:\.\d+)?)\s*([KkMmBb])/) { |match|
        num = $1.to_f
        case $2.downcase
        when 'k'
          (num * 1000).to_i
        when 'm'
          (num * 1000000).to_i
        when 'b'
          (num * 1000000000).to_i
        end
      },
    # description: i.fetch('description')
    )
  end

  showcases = i.fetch('showcases') { Hash.new }
  showcases.each do |showcase|
    create_new_showcase(lora,
                        showcase.fetch('prompt'),
                        showcase.fetch('output').is_a?(Array) ? showcase.fetch('output').first : showcase.fetch('output'))
  end
end