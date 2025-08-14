require 'nokogiri'
require 'json'

def extract(html_file)
  read_file = File.read(html_file)
  html_doc = Nokogiri::HTML(read_file)

  carousel = html_doc.css("a").select do |link|
    # This is some assumption that the carousel is an <a> tag with an image, and a url that comes with sca_esv
    link.css("img").any? && link[:href]&.include?('sca_esv')
  end

  result = { artworks: [] }

  carousel.each do |object|
    name = object.css("img").first[:alt] # since it's an array

    date_div = object.css('div').find { |div| div.text.match(/^\d{4}$/) }
    date = date_div ? date_div.text : nil
    link = "https://www.google.com" + object[:href]

    res = {
      name: name,
      date: [date],
      link: link,
    }

    result[:artworks] << res
  end

  result
end

test = extract("files/van-gogh-paintings.html")
#puts JSON.pretty_generate(test)
File.open("res.json", "w") do |file|
  file.puts JSON.pretty_generate(test)
end

