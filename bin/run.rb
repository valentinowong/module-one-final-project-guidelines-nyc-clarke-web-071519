require_relative '../config/environment'

puts "HELLO WORLD"

prompt = TTY::Prompt.new

result = prompt.collect do
    key(:name).ask('Name?',required: true)
  
    key(:age).ask('Age?', convert: :int)
  
    while prompt.yes?("continue?")
      key(:addresses).values do
        key(:street).ask('Street?', required: true)
        key(:city).ask('City?')
        key(:zip).ask('Zip?', validate: /\A\d{3}\Z/)
      end
    end
  end

binding.pry
puts "0"