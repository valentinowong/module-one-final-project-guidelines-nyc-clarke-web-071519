class User < ActiveRecord::Base
    has_many :user_drinks
    has_many :drinks, through: :user_drinks

    def log_a_drink(date_time, amount, drink_id)
        UserDrink.create(
            datetime: date_time,
            amount: amount,
            drink_id: drink_id,
            user_id: self.id
        )
    end

    def todays_drinks
        user_drinks.select do |user_drink|
            user_drink.datetime > drinking_day_start(DateTime.now) &&
            user_drink.datetime < drinking_day_end(DateTime.now)
        end
    end

    def show_todays_drinks
        todays_drinks.each do |user_drink|
            puts "  #{user_drink.datetime.strftime("%m/%d/%Y %H:%M")} - #{user_drink.amount} oz. #{Drink.find(user_drink.drink_id).name}"
        end
    end

    def last_10_unique_drinks
        last_drinks = []
    end

end