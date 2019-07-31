# prompt = TTY::Prompt.new
# prompt.select("Select one of your recents drinks or log a different drink!")

choices = []

def log_a_drink_choices(user)
  user.five_most_recent_drinks.each do |userdrink|
    choices << "#{userdrink.amount} oz. - #{Drink.find(userdrink.drink_id.name)}"
  end
  choices << "Log a Different Drink"
end

#use array in a prompt including log a new drink

def drink_info_prompt
  puts "What are you having?"
    @prompt.collect do
        key(:name).ask('Drink name?', required: true)
        key(:description).ask('Description of drink')
        key(:alcohol_parcentage).ask('What is the alcohol percentage?')
        key(:amount).ask('What is the amount (oz)')
    end
end

def create_drink
  
end