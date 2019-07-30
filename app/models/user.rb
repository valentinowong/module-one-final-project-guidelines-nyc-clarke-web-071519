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

    #  Takes in a date and returns an array of the drinks that this user had on that drinking date
    def drinks_on_date(date)
        drinks_from_date = user_drinks.select do |user_drink|
            user_drink.datetime >= drinking_day_start(date) &&
            user_drink.datetime < drinking_day_end(date)
        end
        drinks_from_date.sort_by {|user_drink| user_drink.datetime}
    end

    # Takes in an array of drinks a user had and displays them in the console
    def show_drinks(userdrinks)
        userdrinks.each do |user_drink|
            # Changes the user_drink's datetime to the local time
            user_drink_datetime_as_local_time = user_drink.datetime.getlocal
            # Changes the user_drink's datetime to the local time
            user_drink_datetime_display_format = display_date_time(user_drink_datetime_as_local_time)
            puts "  #{user_drink_datetime_display_format} - #{user_drink.amount} oz. #{Drink.find(user_drink.drink_id).name}"
        end
    end

    def todays_drinks
        drinks_today = user_drinks.select do |user_drink|
            current_drinking_day = drinking_day(Time.now)
            user_drink.datetime >= drinking_day_start(current_drinking_day) &&
            user_drink.datetime < drinking_day_end(current_drinking_day)
        end
        drinks_today.sort_by {|user_drink| user_drink.datetime}

    end

    def show_todays_drinks
        todays_drinks.each do |user_drink|
            user_drink_datetime_as_local_time = user_drink.datetime.getlocal
            user_drink_datetime_display_format = display_date_time(user_drink_datetime_as_local_time)
            puts "  #{user_drink_datetime_display_format} - #{user_drink.amount} oz. #{Drink.find(user_drink.drink_id).name}"
        end
    end

    def last_10_unique_drinks
        last_drinks = []
    end

end