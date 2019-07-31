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

# **********************************

def display_homescreen(current_user)
    puts `clear`
    puts "*************** Your Drinks Today *******************"
    puts ""
    current_user.show_todays_drinks
    puts ""
    puts "*****************************************************"
end

def homescreen_next_step_prompt
    prompt = TTY::Prompt.new

    result = prompt.select('What would you like to do?') do |menu|
        menu.choice 'Log a drink', 'Log a drink'
        menu.choice 'See past history', 'See past history'
        menu.choice 'Logout', 'Logout'
    end

    result
end

def homescreen(current_user)
    display_homescreen(current_user)
    next_step = homescreen_next_step_prompt
    next_step
end