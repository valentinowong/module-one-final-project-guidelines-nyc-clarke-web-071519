require_relative '../config/environment'

# current_user = welcome

current_user = User.all[0]

user_input = homescreen(current_user)

if user_input == 'See past history'
    user_input = past_history(current_user)
end

binding.pry
"done"