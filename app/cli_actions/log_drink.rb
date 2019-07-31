@prompt = TTY::Prompt.new



def log_a_drink_prompt(current_user)

  choices = []

    current_user.five_most_recent_drinks.each do |userdrink|
    choices << {name: "#{userdrink.amount} oz. - #{Drink.find(userdrink.drink_id).name}", value: userdrink}
    end
    
    choices << {name: "Log a Different Drink", value: "Different Drink"}
    choices << {name: "back", value: "Main Menu"}
    user_input = @prompt.select("Select one of your Recents Drinks or Log a Different Drink!", choices)

    if user_input == "Different Drink"
      log_new_drink(current_user)
    elsif user_input == "Main Menu"
      homescreen(current_user)
    else
      log_recent_drink(current_user, user_input)
    end
end


def log_new_drink(current_user)
  puts "What are you having?"
    user_input = @prompt.collect do
        key(:name).ask('Drink name?', required: true)
        key(:description).ask('Description of drink')
        key(:alcohol_percentage).ask('What is the alcohol percentage?')
        key(:amount).ask('What is the amount (oz)', required: true)
    end
    
    new_drink = Drink.create(
      name: user_input[:name].capitalize,
      description: user_input[:description],
      alcohol_percentage: user_input[:alcohol_percentage]
    )

    new_userdrink_with_new_drink = UserDrink.create(
      datetime: Time.now,
      amount: user_input[:amount],
      drink_id: new_drink.id,
      user_id: current_user.id
    )
    homescreen(current_user)
end

def log_recent_drink(current_user, userdrink)
    new_userdrink_with_recent_drink = UserDrink.create(
      datetime: Time.now,
      amount: userdrink.amount,
      drink_id: userdrink.drink_id,
      user_id: current_user.id
    )
    homescreen(current_user)
end


def log_drink_on_any_date(current_user, date)
  puts "What drink did you have?"
    user_input = @prompt.collect do
        key(:name).ask('Drink name?', required: true)
        key(:description).ask('Description of drink')
        key(:alcohol_percentage).ask('What is the alcohol percentage?')
        key(:amount).ask('What is the amount (oz)', required: true)
        
        key(:time).ask('What time did you have this drink? (HH:MM am/pm)') do |q| 
          q.validate(/((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))/)
          q.messages[:valid?] = 'Please enter a valid time.'
      end
         
    end
    
    new_drink = Drink.create(
      name: user_input[:name].capitalize,
      description: user_input[:description],
      alcohol_percentage: user_input[:alcohol_percentage]
    )

    new_userdrink_with_new_drink = UserDrink.create(
      datetime: Time.parse("#{date.strftime("%Y/%m/%d")} + #{user_input[:time]}"), 
      amount: user_input[:amount],
      drink_id: new_drink.id,
      user_id: current_user.id
    )
end