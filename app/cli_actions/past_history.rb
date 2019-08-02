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
            q.validate(/([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$)/)
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
    puts "************      ".blue + "Your Drinks From" + "      ************".blue
    puts "************ ".blue + "#{date.strftime("%a, %d %b %Y")} - 8:00 AM" + " ************".blue
    puts "************           ".blue + "until" + "            ************".blue
    puts "************ ".blue + "#{(date+1).strftime("%a, %d %b %Y")} - 7:59 AM" + " ************".blue
    puts ""
    display_drinks_on_date(current_user, date)
    puts ""
    puts "*****************************************************".blue
end

def past_history_next_step_prompt

    prompt = TTY::Prompt.new

    result = prompt.select('What would you like to do?') do |menu|
        menu.choice "Log a drink for this day"
        menu.choice "See next day"
        menu.choice "See previous day"
        menu.choice "Choose another day"
        menu.choice "Return to Today's Drinks"
    end

    result

end

def past_history(current_user)
    date = past_history_date_prompt(current_user)
    past_history_display_and_next_steps(current_user,date)
end

def past_history_display_and_next_steps(current_user, date)
    display_past_history(current_user, date)
    next_step = past_history_next_step_prompt
    if next_step == "Log a drink for this day"
        log_a_drink_prompt_recent_days(current_user, date)
    elsif next_step == "See next day"
        past_history_display_and_next_steps(current_user,date+1)
    elsif next_step == "See previous day"
        past_history_display_and_next_steps(current_user,date-1)
    elsif next_step == "Choose another day"
        past_history(current_user)
    elsif next_step == "Return to Today's Drinks"
        homescreen(current_user)
    end
end
