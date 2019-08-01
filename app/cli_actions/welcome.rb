def welcome
    puts `clear`
    puts "Welcome to Drink Logger 5000!".blue
    puts ""
    welcome_message_prompt
end


#-----------------welcome message prompt--------------#

    #prompt to ask user if they want to sign in or create account..string that is returned is used in "welcome_redirect"
    def welcome_message_prompt
        prompt = TTY::Prompt.new
        welcome_message_input = prompt.select("Please Sign In or Create New Account!", ["Sign In", "Create New Account","Close App"])
        current_user = welcome_redirect(welcome_message_input)
    end
    
    #takes user input and either redirects to our log in method or our create new user method
    def welcome_redirect(welcome_input)
        if welcome_input == "Sign In"
            current_user = log_in_prompt
            homescreen(current_user)
        elsif welcome_input == "Create New Account"
            current_user = create_new_user
            homescreen(current_user)
        elsif welcome_input == "Close App"
            puts `clear`
            puts '     "24 hours in a day. 24 beers in a case. Coincidence? I think not." - H.L. Mencken'.yellow
            puts ""
            puts "     🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺 🍺"
            puts ""
        end
    end
    
#--------------SIGN-UP---------------------#

    #displays a prompt that returns a hash of user input
    def sign_up_prompt
        prompt = TTY::Prompt.new

        puts "Tell us a little about yourself!"
        prompt.collect do
            key(:first_name).ask('What is your first name? (required)', required: true)
            key(:last_name).ask('What is your last name?')
            key(:email).ask('What is your email? (required)', required: true,) { |q| q.validate :email, 'Please enter a valid email address.' }
            key(:weight).ask('What is your weight? (lbs)')
            key(:birthdate).ask('What is your birthdate? (YYYY-MM-DD)') do |q| 
                q.validate(/([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/)
                q.messages[:valid?] = 'Please enter a valid date.'
            end
            key(:gender).select("What is your gender?",['Male','Female','Other'])
            key(:password).ask("Create a password. (required)", required: true)
        end
    end

    #uses the user input hash from "sign_up_prompt" to create a new user in our database
    def create_new_user  
        User.create(sign_up_prompt)
    end

#-----------------SIGN-IN-------------#

    #a prompt that asks a user to enter an email address, uses that user input in the next method
    def log_in_prompt
        prompt = TTY::Prompt.new
        user_email = prompt.ask('What is your email?') 
            # do |q| q.validate(/\A\w+@\w+\Z/, 'Invalid email address')
        log_in_prompt_result(user_email)
    end
    
    #an email validater that takes in the user input from previous method and checks if it matches a User in our database. If it does match we redirect to password.
    #if the email does not match one in our database a prompt is called that asks a user to try again or create new user.
    def log_in_prompt_result(user_email)
        prompt = TTY::Prompt.new
        if User.find_by(email: user_email)
            user = User.find_by(email: user_email)
            password_prompt(user)
        else
<<<<<<< HEAD
=======
            prompt = TTY::Prompt.new
>>>>>>> make_drink2
            user_choice = prompt.select("Sorry! Email does not exist", ["Try again", "Sign up"])
            if_no_email(user_choice)
        end
    end


    #either redirects to trying the email again or to create user based of the user input from "user_choice" prompt
    def if_no_email(user_choice)
        if user_choice == "Try again"
            log_in_prompt
        elsif user_choice == "Sign up"
            create_new_user
        end
    end

    #a prompt asking for a user to input their password. Uses that input in next method.
    def password_prompt(user)
        prompt = TTY::Prompt.new
        user_input = prompt.mask('What is your password?')
        password_validator(user_input,user)
    end

        
    def password_validator(password_attempt,user)
        prompt = TTY::Prompt.new
        if user.password == password_attempt
            current_user = User.find_by(email: user.email)
        else
<<<<<<< HEAD
=======
            prompt = TTY::Prompt.new
>>>>>>> make_drink2
            incorrect_password_user_input = prompt.select("Sorry! wrong password! Would you like to try again?", ["Try again", "Sign up"])
            incorrect_password(incorrect_password_user_input,user)
        end
    end

    def incorrect_password(user_input,user)
        if user_input == "Try again"
            password_prompt(user)
        else
            create_new_user
        end
    end

