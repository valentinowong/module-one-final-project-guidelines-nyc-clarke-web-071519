# Prompts the user for the date they'd like to see for their log
def past_history_date_prompt(current_user)
    choices = current_user.last_5_drinking_days.map do |date|
        {name: date.strftime("%A, %d %B %Y"), value: date}
    end

    choices << {name: "Select a different date", value: "Different Date"}

    prompt = TTY::Prompt.new
    user_input = prompt.select('Which day would you like to see?', choices)

    if user_input == "Different Date"
        user_input = prompt.ask('Please enter a specific date: (YYYY-MM-DD)') do |q| 
            q.validate(/([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/)
            q.messages[:valid?] = 'Please enter a valid date.'
        end
        Date.parse(user_input)
    else
        user_input
    end

end

# Displays the drinks a user had on a specific drinking date 
def display_past_history(current_user, date)
    puts `clear`
    puts "******** ".blue + "Your Drinks on #{date.strftime("%A, %d %B %Y")}" + " ********".blue
    puts ""
    current_user.display_drinks_on_date(date)
    puts ""
    puts "*****************************************************".blue
end

def past_history_next_step_prompt

    prompt = TTY::Prompt.new

    result = prompt.select('What would you like to do?') do |menu|
        menu.choice "Log a drink for this date", "Log a drink for this date"
        menu.choice "See another date", "See another date"
        menu.choice "Return to Today's Drinks", "Return to Today's Drinks"
    end

    result

end

def past_history(current_user)
    inputed_date = past_history_date_prompt(current_user)
    display_past_history(current_user, inputed_date)
    next_step = past_history_next_step_prompt
    if next_step == "See another date"
        past_history(current_user)
    elsif next_step == "Return to Today's Drinks"
        homescreen(current_user)
    elsif next_step == "Log a drink for this date"
        log_drink_on_any_date(current_user, inputed_date)
    end
end