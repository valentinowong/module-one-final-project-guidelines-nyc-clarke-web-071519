# Helper Methods
# **********************************
def drinking_day_start(date)
    DateTime.parse(date.strftime("%Y/%m/%d")+"T12:00:00-04:00")
end

def drinking_day_end(date)
    DateTime.parse((date+1).strftime("%Y/%m/%d")+"T11:59:59-04:00")
end

# **********************************

def homescreen(current_user)

    current_user.show_todays_drinks

    prompt = TTY::Prompt.new

    result = prompt.select('What would you like to do?') do |menu|
        menu.choice 'Log a Drink', 1
        menu.choice 'See Past History', 2
        menu.choice 'Logout', 3
    end

    result

end