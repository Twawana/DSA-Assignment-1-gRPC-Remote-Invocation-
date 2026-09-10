import ballerina/io;

public function main() returns error? {
    RentalServiceClient rentalClient = check new ("http://localhost:9090");

    PropertyResponse addResponse = check rentalClient->AddProperty({
        host_id: "host-001",
        name: "Seaside Cottage",
        location: "Swakopmund",
        property_type: "Cottage",
        price_per_night: 850.0,
        status: "AVAILABLE"
    });
    io:println("Added property: ", addResponse.message);
    string propertyId = addResponse.property.property_id;

    CreateUsersStreamingClient usersClient = check rentalClient->CreateUsers();
    check usersClient->sendUserRequest({
        user_id: "host-001",
        name: "Host One",
        role: "HOST",
        email: "host@example.com"
    });
    check usersClient->sendUserRequest({
        user_id: "guest-001",
        name: "Guest One",
        role: "GUEST",
        email: "guest@example.com"
    });
    check usersClient->complete();
    CreateUsersResponse? usersResponse = check usersClient->receiveCreateUsersResponse();
    io:println("Users registered: ", usersResponse);

    PropertyResponse updateResponse = check rentalClient->UpdateProperty({
        property_id: propertyId,
        price_per_night: 900.0,
        status: "AVAILABLE"
    });
    io:println("Property updated: ", updateResponse.message);

    stream<PropertyResponse, error?> properties = check rentalClient->ListAvailableProperties({
        location: "",
        max_price: 0.0
    });
    boolean foundProperty = false;
    check properties.forEach(function(PropertyResponse property) {
        foundProperty = true;
        io:println("Available property: ", property.property.name);
    });
    if !foundProperty {
        io:println("No available properties found.");
    }

    PropertyResponse searchResponse = check rentalClient->SearchProperty({
        property_id: propertyId
    });
    if searchResponse.success {
        io:println("Property found: ", searchResponse.property.name);
    } else {
        io:println("Property not available: ", searchResponse.message);
    }

    BookingResponse bookingResponse = check rentalClient->BookProperty({
        guest_id: "guest-001",
        property_id: propertyId,
        check_in: "2026-09-20",
        check_out: "2026-09-23"
    });
    io:println("Booking response: ", bookingResponse.message);

    BookingConfirmation confirmation = check rentalClient->ConfirmBooking({
        booking_ref: bookingResponse.booking_ref
    });
    io:println("Booking confirmed: ", confirmation.success);
    io:println("Total cost: ", confirmation.total_cost);

    PropertyListResponse removeResponse = check rentalClient->RemoveProperty({
        property_id: propertyId,
        host_id: "host-001"
    });
    io:println("Property removed: ", removeResponse.message);
}