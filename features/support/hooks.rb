# Scenarios that modify the current datetime can be tagged so, once
# they finish, time will be reverted back to its original state.
#
After("@date_travel") { travel_back }
