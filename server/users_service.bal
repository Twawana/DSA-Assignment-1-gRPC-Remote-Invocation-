public function registerUser(string userId, string name, string role, string email)
        returns error? {

    if role != "HOST" && role != "GUEST" {
        return error("Invalid role: must be HOST or GUEST");
    }

    if name.trim().length() == 0 {
        return error("Name cannot be empty");
    }

    if email.trim().length() == 0 {
        return error("Email cannot be empty");
    }

    userStore[userId] = {
        userId: userId,
        name: name,
        role: role,
        email: email
    };

    return;
}