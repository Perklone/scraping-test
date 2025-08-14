require_relative "results/extractor"

# van-gogh-paintings.html
test = Extractor.new.extract("files/van-gogh-paintings.html")
File.open("output/van-gogh.json", "w") do |file|
  file.puts JSON.pretty_generate(test)
end

# monet-paintings.html
test = Extractor.new.extract("files/monet-paintings.html")
File.open("output/monet.json", "w") do |file|
  file.puts JSON.pretty_generate(test)
end

# van-gogh-paintings.html
test = Extractor.new.extract("files/dog-breed-list.html")
File.open("output/dog-breed.json", "w") do |file|
  file.puts JSON.pretty_generate(test)
end

