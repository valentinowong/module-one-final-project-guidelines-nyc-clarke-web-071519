def all_user_userdrinks
  userdrinks = UserDrink.find_by user_id: self
end


def all_user_drinks
  all_user_userdrinks.drink_id
end


def log_drink_or_recent_prompt
end



def log drink
end