import ballerina/io;

RentalServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    PropertyRequest addPropertyRequest = {host_id: "ballerina", name: "ballerina", location: "ballerina", property_type: "ballerina", price_per_night: 1, status: "ballerina"};
    PropertyResponse addPropertyResponse = check ep->AddProperty(addPropertyRequest);
    io:println(addPropertyResponse);

    UpdatePropertyRequest updatePropertyRequest = {property_id: "ballerina", price_per_night: 1, status: "ballerina"};
    PropertyResponse updatePropertyResponse = check ep->UpdateProperty(updatePropertyRequest);
    io:println(updatePropertyResponse);

    RemovePropertyRequest removePropertyRequest = {property_id: "ballerina", host_id: "ballerina"};
    PropertyListResponse removePropertyResponse = check ep->RemoveProperty(removePropertyRequest);
    io:println(removePropertyResponse);

    SearchPropertyRequest searchPropertyRequest = {property_id: "ballerina"};
    PropertyResponse searchPropertyResponse = check ep->SearchProperty(searchPropertyRequest);
    io:println(searchPropertyResponse);

    BookingRequest bookPropertyRequest = {guest_id: "ballerina", property_id: "ballerina", check_in: "ballerina", check_out: "ballerina"};
    BookingResponse bookPropertyResponse = check ep->BookProperty(bookPropertyRequest);
    io:println(bookPropertyResponse);

    ConfirmBookingRequest confirmBookingRequest = {booking_ref: "ballerina"};
    BookingConfirmation confirmBookingResponse = check ep->ConfirmBooking(confirmBookingRequest);
    io:println(confirmBookingResponse);

    ListPropertiesRequest listAvailablePropertiesRequest = {location: "ballerina", max_price: 1};
    stream<PropertyResponse, error?> listAvailablePropertiesResponse = check ep->ListAvailableProperties(listAvailablePropertiesRequest);
    check listAvailablePropertiesResponse.forEach(function(PropertyResponse value) {
        io:println(value);
    });

    UserRequest createUsersRequest = {user_id: "ballerina", name: "ballerina", role: "ballerina", email: "ballerina"};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendUserRequest(createUsersRequest);
    check createUsersStreamingClient->complete();
    CreateUsersResponse? createUsersResponse = check createUsersStreamingClient->receiveCreateUsersResponse();
    io:println(createUsersResponse);
}
