// users_service.bal
// Business logic backing the create_users client-streaming RPC.
// The generated service will call this once per streamed UserRequest,
// then send a single CreateUsersResponse after the stream ends
// (see README.md "Wiring the generated service").

public function registerUser(string userId, string name, string role, string email)
        returns error? {

    // TODO 1: validate role is "HOST" or "GUEST" (reject anything else).
    // TODO 2: validate name/email are non-empty.
    // TODO 3: store into userStore (userStore[userId] = { ... }).
    // Return an error to reject a single bad record without killing
    // the whole stream if you want per-record validation feedback.

    return error("Not implemented: registerUser");
}
