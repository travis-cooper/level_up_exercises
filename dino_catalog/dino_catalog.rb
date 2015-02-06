require 'csv'

# function to load a file into an array
def load_dinodex(dino_array, filename)
  CSV.foreach(filename, headers: true) do |row|
    dino = row.to_hash
    dino["name"] = row["NAME"]
    dino["period"] = row["PERIOD"]
    dino["walk"] = row["WALKING"]
    dino["diet"] = row["DIET"]
    dino["size"] = row["WEIGHT_IN_LBS"].to_i > 4000 ? "Big" : "Small"
    dino_array.push(dino)
  end
end

def load_africandinos(dino_array, filename)
  CSV.foreach(filename, headers: true) do |row|
    dino = row.to_hash
    dino["name"] = row["Genus"]
    dino["period"] = row["Period"]
    dino["walk"] = row["Walking"]
    dino["diet"] = row["Carnivore"] == "Yes" ? "Carnivore" : "Herbivore"
    dino["size"] = row["Weight"].to_i > 4000 ? "Big" : "Small"
    dino_array.push(dino)
  end
end


# help function
def show_help()
  puts """
  Commands -- Action
    q -- quit dino catalog
    ? -- display this help menu
    show -- print your last search to the screen
    reset -- resets search to search over entire data set
    find -- search for a particular set of dinos
      find is followed by a criteria word which is
      in turn followed by a value to look for on that criteria
      EXAMPLE: find walk biped
  Criteria List:
    name
    period
    walk
    diet
    size
  """
end

def show_search(search_results)
  hide_keys = ["name", "period", "walk", "diet", "size"]
  search_results.each do |row|
    row.each do |key, value|
      if !hide_keys.include? key and !value.nil?
        puts key + ": " + value
      end
    end
    print "Search found " + search_results.size.to_s +  " dinos\n"
  end
end

def process_command(command, prev_search, whole_catalog)
  if command[0] == "q"
    return 
  elsif command[0] == "?"
    show_help()
    return prev_search
  elsif command[0] == "reset"
    return whole_catalog
  elsif command[0] == "show"
    show_search(prev_search)
    return prev_search
  elsif command[0] == "find"
    prev_search = search_for(command, prev_search)
    show_search(prev_search)
    return prev_search
  else
    puts "Not a valid command: type '?' for help"
    return prev_search
  end

end

def search_for(command, catalog)
  field = command[1]
  value = command[2]
  result = []
  catalog.each do |dino|
    if dino[field].downcase == value.downcase
      result.push(dino)
    end
  end
  return result
end

# main program loop
def main()
  dino_catalog = []
  file_list = ["african_dinosaur_export.csv", "dinodex.csv"]
  # load in files
  load_africandinos(dino_catalog, file_list[0])
  load_dinodex(dino_catalog, file_list[1])
  # debug display of hash
  show_search(dino_catalog)
  
  # loop til "q"
  command = [""]
  last_search = dino_catalog
  while command[0] != "q"
    print "Dino Catalog (enter '?' for help)> "
    command = gets.chomp().split()
    last_search = process_command(command, last_search, dino_catalog)
  end

end

main()
