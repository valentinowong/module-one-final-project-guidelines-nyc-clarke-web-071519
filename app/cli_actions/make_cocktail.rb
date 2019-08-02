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

# Prompts the user to select a spirit
def select_a_spirit_prompt
    prompt = TTY::Prompt.new

    result = prompt.select('What spirit would you like to start with?') do |menu|
        menu.choice 'Vodka', vodka_names
        menu.choice 'Whiskey', whiskey_names
        menu.choice 'Tequila', tequila_names
        menu.choice 'Rum', rum_names
        menu.choice 'Gin', gin_names
    end

    result
end

# Takes in an array of spirit names and returns an array of hashes of all the cocktails
def get_cocktails(spirit_names)
    all_drink_and_ids = []
    spirit_names.each do |ingredient|
        response = RestClient.get 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=' + ingredient
        drinks = JSON.parse(response)
        drinks["drinks"].each do |drink|
            all_drink_and_ids << {name: drink["strDrink"], value: drink["idDrink"]}
        end
    end
    all_drink_and_ids.sort_by {|drink| drink[:name]}.uniq
end

# Given an array of hashes of cocktail names and cocktail_db drink ids, displays them in the console
def select_a_cocktail_prompt(cocktails_array)
    cocktails_array
    prompt = TTY::Prompt.new
    selected_cocktail = prompt.select("Select a cocktail you'd like to make! 🍹 🍸 🍹", cocktails_array)
end

# Takes a drink id from the cocktail db website and returns that cocktail's info in a hash
def get_cocktail_info_from_cocktail_db(cocktail_db_drink_id)
    response = RestClient.get 'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=' + cocktail_db_drink_id
    drink_info = JSON.parse(response)["drinks"][0]
end

# Given a specific cocktail info in hash format, displays that cocktails info in the console
def display_cocktail_info(cocktail_info_hash)
    puts `clear`
    puts "*************** ".blue + "#{cocktail_info_hash["strDrink"].split.map(&:capitalize).join(' ')}" + " *******************".blue
    puts ""
    puts "INGREDIENTS:"
    puts ""
    (1..15).to_a.each do |n|
        if !cocktail_info_hash["strMeasure#{n}"].nil?
            if !cocktail_info_hash["strIngredient#{n}"].nil?
                if !cocktail_info_hash["strMeasure#{n}"].chomp.strip.empty? || !cocktail_info_hash["strIngredient#{n}"].chomp.strip.empty?
                    puts "#{cocktail_info_hash["strMeasure#{n}"].chomp.strip} #{cocktail_info_hash["strIngredient#{n}"].chomp.strip.split.map(&:capitalize).join(' ')}".yellow
                end
            else
                if !cocktail_info_hash["strMeasure#{n}"].chomp.strip.empty?
                    puts "#{cocktail_info_hash["strMeasure#{n}"].chomp.strip}".yellow
                end
            end
        elsif !cocktail_info_hash["strIngredient#{n}"].nil?
            if !cocktail_info_hash["strIngredient#{n}"].chomp.strip.empty?    
                puts "#{cocktail_info_hash["strIngredient#{n}"].chomp.strip.split.map(&:capitalize).join(' ')}".yellow
            end
        end
    end
    puts ""
    puts "INSTRUCTIONS:"
    puts ""
    puts "#{cocktail_info_hash["strInstructions"].chomp}".yellow
    puts ""
    puts "************************************************".blue
end

# Prompts the user on what they want to do after making a cocktail
def cocktail_next_steps_prompt(user, cocktail_info)

    prompt = TTY::Prompt.new

    result = prompt.select('What would you like to do now?') do |menu|
        menu.choice "Log this drink"
        menu.choice "Make another cocktail"
        menu.choice "Return to Today's Drinks"
    end

    cocktail_next_steps_action(user, result, cocktail_info)

end

# Prompts the user on what they want to do after logging a cocktail
def cocktail_next_steps_after_logging_prompt(user, cocktail_info)

    prompt = TTY::Prompt.new

    result = prompt.select('What would you like to do now?') do |menu|
        menu.choice "Make another cocktail"
        menu.choice "Return to Today's Drinks"
    end

    cocktail_next_steps_action(user, result, cocktail_info)

end

# Takes a user input from the next steps prompts and directs them to where they want to go
def cocktail_next_steps_action(user, user_input, cocktail_info)
    if user_input == "Make another cocktail"
        make_a_cocktail(user)
    elsif user_input == "Return to Today's Drinks"
        homescreen(user.reload)
    elsif user_input == "Log this drink"
        log_cocktail(user, cocktail_info)
        cocktail_next_steps_after_logging_prompt(user, cocktail_info)
    end
end

# Takes in a user and a hash of info on a cocktail and logs the drink today at the current time for that user
def log_cocktail(current_user, cocktail_info)
    prompt = TTY::Prompt.new

    user_input = prompt.ask("How much did you have? (oz.)") do |q|
        q.required true
        q.validate /^\+?(0|[1-9]\d*)$/
    end

    # Create the new drink object from the inputted info
    new_drink = Drink.create(name: cocktail_info["strDrink"].split.map(&:capitalize).join(' '))

    # Log the new userdrink at the current datetime
    new_userdrink_with_new_drink = UserDrink.create(
      datetime: Time.now,
      amount: user_input,
      drink_id: new_drink.id,
      user_id: current_user.id
    )
    puts "We've logged your #{new_drink[:name]} for today!"
end

def make_a_cocktail(current_user)
    spirit = select_a_spirit_prompt
    cocktails = get_cocktails(spirit)
    cocktail = select_a_cocktail_prompt(cocktails)
    cocktail_info = get_cocktail_info_from_cocktail_db(cocktail)
    display_cocktail_info(cocktail_info)
    cocktail_next_steps_prompt(current_user, cocktail_info)
end