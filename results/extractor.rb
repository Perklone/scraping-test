# frozen_string_literal: true

require 'nokogiri'
require 'json'

class Extractor
  def extract(html_file)
    parsed_html = read_html(html_file)

    carousel = parsed_html.css('a').select do |link|
      # This is some assumption that the carousel is an <a> tag with an image, and a url that comes with sca_esv
      # Could break if user is logged in, since the top right GAccount is a <a> that have <img> (same characteristics.)
      # Based on observation, this is quite different from the "People also search for" section where the <a> tag is nested with <div> below it.
      link.css('img').any? && link[:href]&.include?('sca_esv')
    end

    result = { artworks: [] }

    carousel.each do |object|
      primary_div = object.css('div')[1].text
      secondary_div = object.css('div')[2].text # This is not always text on other carousel.
      link = "https://www.google.com#{object[:href]}"

      # Alternatively, You can do something like
      # name = object.css('img').first[:alt] # since it's an array
      # date_div = object.css('div').find { |div| div.text.match(/^\d{4}$/) }
      # date = date_div&.text
      # but this is brittle and prune to break if the order changes.
      # But the method that I used also can be prone to mistake (if the alt is not properly named.)

      res = {
        name: primary_div,
        link: link
      }

      res[:extensions] = [secondary_div] unless secondary_div.empty? || !secondary_div.match?(/^\d{4}$/)

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
