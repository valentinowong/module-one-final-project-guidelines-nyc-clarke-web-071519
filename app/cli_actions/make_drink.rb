# ------ Methods that list out the different ways TheCocktailDB api lists out the main spirits ------

# Returns an array with the all the different ways to list VODKA as an ingredient
def vodka_names
    ["Vodka", "Lemon vodka", "Peach Vodka", "Absolut Citron", "Absolut Vodka", "Vanilla vodka", "Raspberry vodka", "Absolut Kurant", "Cranberry vodka"]
end

# Returns an array with the all the different ways to list WHISKEY as an ingredient
def whiskey_names
    ["Whiskey", "Whisky", "Scotch", "Blended whiskey", "Bourbon", "Irish whiskey", "Johnnie Walker", "Jack Daniels", "Crown Royal", "Wild Turkey", "Jim Beam", "Blended Scotch", "Rye whiskey"]
end

# Returns an array with the all the different ways to list RUM as an ingredient
def rum_names
    ["Rum", "Light rum", "Dark rum", "Spiced rum", "Bacardi Limon", "White Rum"]
end

# Returns an array with the all the different ways to list GIN as an ingredient
def gin_names
    ["Gin"]
end

# Returns an array with the all the different ways to list TEQUILA as an ingredient
def tequila_names
    ["Tequila", "Mezcal"]
end

# --------------------------------------------------------------------------------------------------

# Takes in an array of spirit names and returns an array of hashes of all the drinks 
def get_drinks(spirit_names)
    all_drink_and_ids = []
    spirit_names.each do |ingredient|
        response = RestClient.get 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=' + ingredient
        drinks = JSON.parse(response)
        drinks["drinks"].each do |drink|
            all_drink_and_ids << {name: drink["strDrink"], value: drink["idDrink"]}
        end
    end
    all_drink_and_ids.sort_by {|drink| drink[:name]}
end

def get_drink_info_from_cocktail_db(cocktail_db_drink_id)
    response = RestClient.get 'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=' + cocktail_db_drink_id
    drink_info = JSON.parse(response)["drinks"][0]
end

def display_drink_info(drink_info_hash)
    puts `clear`
    puts "DRINK:".blue + " #{drink_info_hash["strDrink"].capitalize}".yellow
    puts ""
    puts "INGREDIENTS:".blue
    puts ""
    (1..15).to_a.each do |n|
        unless drink_info_hash["strMeasure#{n}"].chomp == "" && drink_info_hash["strIngredient#{n}"] == ""
            puts "#{drink_info_hash["strMeasure#{n}"].chomp}#{drink_info_hash["strIngredient#{n}"]}".yellow
        end
    end
    puts ""
    puts "INSTRUCTIONS:".blue
    puts "#{drink_info_hash["strInstructions"].chomp}".yellow
end


# Max drinks returned = 110
# Display 20s
