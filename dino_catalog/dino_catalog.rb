require 'csv'

file_list = ["african_dinosaur_export.csv", "dinodex.csv"]

dino_array = []
file_list.each do |filename|
  CSV.foreach(filename, headers: true) do |row|
    dino_array.push(row.to_hash)
  end
end

dino_array.each do |row|
  puts row.inspect
end
