# Helper Methods
# **********************************

# Takes in a date object and returns the starting datetime of that drinking date
def drinking_day_start(date)
    date.to_time + 28800
end

# Takes in a date object and returns the ending datetime of that drinking date
def drinking_day_end(date)
    date.to_time + 115199
end

# Takes in a datetime object and returns the drinking date
def drinking_day(datetime)
    if datetime.hour >= 8
        Date.parse(datetime.strftime("%Y/%m/%d %I:%M %p"))
    else
        Date.parse(datetime.strftime("%Y/%m/%d %I:%M %p")) - 1
    end
end

#Takes in a datetime object and returns it formatted for display
def display_date_time(datetime)
    datetime.strftime("%m/%d/%Y - %I:%M %p")
end

# Takes in a date and displays the drinks a user had on that drinking date
def display_drinks_on_date(user, date)
    users_drinks_on_date = user.drinks_on_date(date)
    user.display_drinks(users_drinks_on_date)
end

# Shows the drinks a user had on the current drinking date
def show_todays_drinks(user)
    display_drinks_on_date(user, drinking_day(Time.now))
end

# **********************************

def display_homescreen(current_user)
    puts `clear`
    puts "*************** ".blue + "Your Drinks Today" + " *******************".blue
    puts ""
    show_todays_drinks(current_user)
    puts ""
    puts "*****************************************************".blue
end

def homescreen_next_step_prompt
    prompt = TTY::Prompt.new

    result = prompt.select('What would you like to do?') do |menu|
        menu.choice 'Log a drink'
        menu.choice 'Make a cocktail'
        menu.choice "See previous day"
        menu.choice 'See past history'
        menu.choice 'Logout'
    end

    result
end

def homescreen(current_user)
    display_homescreen(current_user)
    next_step = homescreen_next_step_prompt
    if next_step == 'See past history'
        past_history(current_user)
    elsif next_step == 'Logout'
        current_user = welcome
    elsif next_step == 'Log a drink'
        log_a_drink_today_prompt(current_user)
    elsif next_step == 'Make a cocktail'
        make_a_cocktail(current_user)
    elsif next_step == "See previous day"
        past_history_display_and_next_steps(current_user,Date.today - 1)
    end
end