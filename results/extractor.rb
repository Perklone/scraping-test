# frozen_string_literal: true

require 'nokogiri'
require 'json'

class Extractor
  def extract(html_file)
    parsed_html = read_html(html_file)

    carousel = parsed_html.css('a').select do |link|
      # This is some assumption that the carousel is an <a> tag with an image, and a url that comes with sca_esv
      # Based on observation, this is quite different from the "People also search for" section where the <a> tag is nested with <div> below it.
      link.css('img').any? && link[:href]&.include?('sca_esv')
    end

    result = { artworks: [] }

    carousel.each do |object|
      name = object.css('img').first[:alt] # since it's an array
      date_div = object.css('div').find { |div| div.text.match(/^\d{4}$/) }
      link = "https://www.google.com#{object[:href]}"

      # Alternatively, You can do something like
      # name = object.css.('div')[1]
      # date = object.css.('div')[2]
      #
      # but this is brittle and prune to break if the order changes.
      # But the method that I used also can be prone to mistake (if the alt is not properly named.)

      res = {
        name: name,
        link: link
      }

      date = date_div&.text
      res[:extensions] = [date] unless date.nil?

      image = object.css('img').first['data-src']
      res[:image] = image unless image.nil?

      result[:artworks] << res
    end

    result
  end

  private

  def read_html(html_file)
    read_file = File.read(html_file)

    Nokogiri::HTML(read_file)
  end
end
