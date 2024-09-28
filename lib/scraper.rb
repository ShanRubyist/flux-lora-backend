require 'nokogiri'
require 'open-uri'
require 'json'

class Scraper
  def self.scrape_data(url, &block)
    html = URI.open(url,
                    'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36')

    doc = Nokogiri::HTML(html)

    yield doc, url
  end

  def self.scrape(urls, &block)
    puts "[*]Scraping #{urls.length} urls"

    index = 1
    urls.map do |url|
      puts "[*]Sleeping a few seconds"
      sleep Random.rand(1..10)

      puts "[*]Scraping (#{index}/#{urls.length}): #{url}"
      index += 1
      self.scrape_data(url, &block)
    end
  end

  def self.output_data(hash, file_name = File.join(Rails.root, 'lib/output.json'))
    output_file = File.open(file_name, 'w')
    output_file.write(JSON.pretty_generate(hash))
    output_file.close
  end
end

urls = File.readlines(File.join(Rails.root, "lib/urls.txt")).map(&:strip)

data = Scraper.scrape(urls) do |doc, url|
  model = doc.css('h3 >span').to_a
  model_author = model[0].text.strip
  model_name = model[2].text.split("\n")[0].strip
  model_value = model_author + '/' + model_name

  description = doc.css('p.mt-1').text.strip
  runs = doc.css('span.text-r8-sm')[1].text.sub('runs', '').strip

  # Get cost credits
  html = URI.open(url.sub('/examples?output=json', ''),
                  'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36')
  doc2 = Nokogiri::HTML(html)
  dom = doc2.css("div#pricing > p")
  cost_credits = nil
  if dom.text =~ /\$(\d+(\.\d+)?)/
    cost_credits = $1.to_f
  end

  unless cost_credits
    json_str = doc2.css('div.max-w-2xl > script[type="application/json"]')
    json = JSON.parse(json_str[0]&.text || '{}')

    if json['officialModel']
      cost_credits = json.fetch('officialModel').fetch('cost_per_billing_unit_for_output_dollars')
    else
      puts "[-] ERROR: cost_credits is nil"
    end

  end

  # Get showcases
  json_str = doc.css('div.model-content > script[type="application/json"]')
  json = JSON.parse(json_str[0]&.text || '{}')

  showcases = []
  json.fetch('examples') { [] }.each do |showcase|
    showcases << {
      prompt: showcase.fetch('input').fetch('prompt'),
      predict_id: showcase.fetch('id'),
      output: showcase.fetch('output'),
      data: showcase,
    }
  end

  result = {
    model: model_name,
    model_value: model_value,
    description: description,
    runs: runs,
    cost_credits: cost_credits,
    showcases: showcases
  }
end

Scraper.output_data(data)