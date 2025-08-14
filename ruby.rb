require_relative "results/extractor"

test = Extractor.new.extract("files/monet-paintings.html")
File.open("monet.json", "w") do |file|
  file.puts JSON.pretty_generate(test)
end

