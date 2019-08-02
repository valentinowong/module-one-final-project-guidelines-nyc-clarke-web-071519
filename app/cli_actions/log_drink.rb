# Use this method to log a drink from the homescreen (Today's Drinks)
def log_a_drink_today_prompt(current_user)
  prompt = TTY::Prompt.new

  choices = []

    current_user.five_most_recent_drinks.each do |userdrink|
    choices << {name: "#{userdrink.amount} oz. - #{Drink.find(userdrink.drink_id).name}", value: userdrink}
    end
    
    choices << {name: "Log a new drink", value: "Different Drink"}
    choices << {name: "Back", value: "Main Menu"}
    
    prompt = TTY::Prompt.new
    user_input = prompt.select("Select a drink or log a different drink!", choices)

    if user_input == "Different Drink"
      log_new_drink_today(current_user)
    elsif user_input == "Main Menu"
      homescreen(current_user)
    else
      log_recent_drink_today(current_user, user_input)
    end
end

# Prompts the user to manually enter info to log a new userdrink
def log_new_drink_today(current_user)
  prompt = TTY::Prompt.new

  puts "What are you having?"
  user_input = prompt.collect do
      key(:name).ask("What's this drink called? (required)" , required: true)
      key(:description).ask('Describe the drink. (optional)')
      key(:alcohol_percentage).ask('What is the alcohol percentage? (optional)')
      key(:amount).ask('How much did you have? (oz)', required: true)
  end
    
  # Create the new drink object from the inputted info
  new_drink = Drink.create(
    name: user_input[:name].split.map(&:capitalize).join(' '),
    description: user_input[:description],
    alcohol_percentage: user_input[:alcohol_percentage]
  )

  # Log the new userdrink at the current datetime
  new_userdrink_with_new_drink = UserDrink.create(
    datetime: Time.now,
    amount: user_input[:amount],
    drink_id: new_drink.id,
    user_id: current_user.id
  )
  homescreen(current_user.reload)
end

# Logs a new userdrink using the info from a recent drink the user has had
def log_recent_drink_today(current_user, userdrink)
    new_userdrink_with_recent_drink = UserDrink.create(
      datetime: Time.now,
      amount: userdrink.amount,
      drink_id: userdrink.drink_id,
      user_id: current_user.id
    )  
    homescreen(current_user.reload)
end

# Prompts the user to manually enter info to log a new userdrink on a specific date

def log_a_drink_prompt_recent_days(current_user, date)
  prompt = TTY::Prompt.new

  choices = []

  current_user.five_most_recently_logged_drinks.each do |userdrink|
    choices << {name: "#{userdrink.amount} oz. - #{Drink.find(userdrink.drink_id).name}", value: userdrink}
    end
    
    choices << {name: "Log a different drink", value: "Different Drink"}
    choices << {name: "Back", value: "Main Menu"}
    user_input = prompt.select("Select a drink or log a different drink!", choices)

    if user_input == "Different Drink"
      log_drink_on_any_date(current_user, date)
    elsif user_input == "Main Menu"
      past_history_display_and_next_steps(current_user, date)
    else
      log_recent_drink_any_date(current_user, user_input, date)
    end
end




def log_drink_on_any_date(current_user, date)
  prompt = TTY::Prompt.new

  puts "What drink did you have?"
    user_input = prompt.collect do
      key(:name).ask("What's this drink called? (required)", required: true)
      key(:description).ask('Describe the drink. (optional)')
      key(:alcohol_percentage).ask('What is the alcohol percentage? (optional)')
      key(:amount).ask('How much did you have? (oz)', required: true)
      key(:time).ask('What time did you have this drink? (HH:MM am/pm)') do |q| 
        q.validate(/((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))/)
        q.messages[:valid?] = 'Please enter a valid time.'
      end
         
    end
    
  new_drink = Drink.create(
    name: user_input[:name].split.map(&:capitalize).join(' '),
    description: user_input[:description],
    alcohol_percentage: user_input[:alcohol_percentage]
  )

    new_date = date

  if Time.parse(user_input[:time]).hour <= 8
    new_date += 1
  end

  new_userdrink_with_new_drink = UserDrink.create(
    datetime: Time.parse("#{new_date.strftime("%Y/%m/%d")} + #{user_input[:time]}"), 
    amount: user_input[:amount],
    drink_id: new_drink.id,
    user_id: current_user.id
  )
  past_history_display_and_next_steps(current_user.reload, date)
end

def log_recent_drink_any_date(current_user, userdrink, date) 
  prompt = TTY::Prompt.new
  recent_time = prompt.ask('What time did you have this drink? (HH:MM am/pm)') do |q|
    q.validate(/((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))/)
      q.messages[:valid?] = 'Please enter a valid time.'
  end
  
  if Time.parse(recent_time).hour <= 8
    date += 1
  end

  new_userdrink_with_recent_drink = UserDrink.create(
    datetime: Time.parse("#{date.strftime("%Y/%m/%d")} + #{recent_time}"),
    amount: userdrink.amount,
    drink_id: userdrink.drink_id,
    user_id: current_user.id 
  )  
  if new_userdrink_with_recent_drink[:datetime].getlocal.hour <= 8
    past_history_display_and_next_steps(current_user.reload, date-1)
  elsif new_userdrink_with_recent_drink[:datetime].getlocal.hour >= 8
    past_history_display_and_next_steps(current_user.reload, date)
  end
end