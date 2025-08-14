require 'nokogiri'
require 'json'

def extract(html_file)
  read_file = File.read(html_file)
  html_doc = Nokogiri::HTML(read_file)

  carousel = html_doc.css("a").select do |link|
    # This is some assumption that the carousel is an <a> tag with an image, and a url that comes with sca_esv
    # Based on observation, this is quite different from the "People also search for" section where the <a> tag is nested with <div> below it.
    link.css("img").any? && link[:href]&.include?('sca_esv')
  end

  result = { artworks: [] }

  carousel.each do |object|
    name = object.css("img").first[:alt] # since it's an array
    date_div = object.css('div').find { |div| div.text.match(/^\d{4}$/) }
    link = "https://www.google.com" + object[:href]

=begin
Alternatively, You can do something like
name = object.css.('div')[1]
date = object.css.('div')[2]

but this is brittle and prune to break if the order changes.
But the method that I used also can be prone to mistake (if the alt is not properly named.)
=end

    res = {
      name: name,
      link: link,
    }

    date = date_div ? date_div.text : nil
    res[:extensions] = [date] if !date.nil?

    image = object.css("img").first["data-src"]
    res[:image] = image if !image.nil?

    result[:artworks] << res
  end

  result
end

test = extract("files/van-gogh-paintings.html")
#puts JSON.pretty_generate(test)
File.open("res.json", "w") do |file|
  file.puts JSON.pretty_generate(test)
end

