// users_service.bal

final string[] VALID_ROLES = ["HOST", "GUEST"];

public function registerUser(string userId, string name, string role, string email)
        returns error? {

    if userId.trim() == "" {
        return error("userId is required");
    }
    if name.trim() == "" {
        return error("name is required");
    }
    if email.trim() == "" {
        return error("email is required");
    }
    if VALID_ROLES.indexOf(role) is () {
        return error("Invalid role: " + role);
    }

    userStore[userId] = {
        userId: userId,
        name: name,
        role: role,
        email: email
    };

    return;
}