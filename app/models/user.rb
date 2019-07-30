class User < ActiveRecord::Base
    has_many :user_drinks
    has_many :drinks, through: :user_drinks

    # Log a specific drink for this user on a specific datetime, for a specific amount
    def log_a_drink(date_time, amount, drink_id)
        UserDrink.create(
            datetime: date_time,
            amount: amount,
            drink_id: drink_id,
            user_id: self.id
        )
    end

    #  Takes in a date and returns an array of the userdrinks that this user had on that drinking date
    def drinks_on_date(date)
        drinks_from_date = user_drinks.select do |user_drink|
            user_drink.datetime >= drinking_day_start(date) &&
            user_drink.datetime < drinking_day_end(date)
        end
        drinks_from_date.sort_by {|user_drink| user_drink.datetime}
    end

    # Takes in an array of userdrinks a user had and displays them in the console
    def display_drinks(userdrinks)
        userdrinks.each do |user_drink|
            # Changes the user_drink's datetime to the local time
            user_drink_datetime_as_local_time = user_drink.datetime.getlocal
            # Takes a datetime and 
            user_drink_datetime_display_format = display_date_time(user_drink_datetime_as_local_time)
            puts "  #{user_drink_datetime_display_format} - #{user_drink.amount} oz. #{Drink.find(user_drink.drink_id).name}"
        end
    end

    # Takes in a date and displays the drinks a user had on that drinking date
    def display_drinks_on_date(date)
        users_drinks_on_date = drinks_on_date(date)
        display_drinks(users_drinks_on_date)
    end

    # Shows the drinks a user had on the current drinking date
    def show_todays_drinks
        display_drinks_on_date(drinking_day(Time.now))
    end


    #array of a users 5 most recent drinks
    def five_most_recent_drinks
        array = []
        sorted_user_drinks = user_drinks.sort_by {|userdrink| userdrink.datetime}
        sorted_user_drinks.each do |userdrink|
            if array.length < 5 && (!array.include?(#userdrink.id && userdrink.amount)) - If a userdrink that has this userdrink's drink_id AND amount is not already in the array, add this userdrink to the array
                array << userdrink
            end
            array
        end
    end



end