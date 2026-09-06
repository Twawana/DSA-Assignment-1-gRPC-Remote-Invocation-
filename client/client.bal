// client.bal
// Demonstrates all 8 RPCs against the RentalService server.
//
// IMPORTANT: after you run `bal grpc` (see README.md), it generates a
// client object for you — conventionally named "<ServiceName>Client",
// i.e. RentalServiceClient — with one method per rpc, already
// implemented to make the network call. You do NOT hand-write the
// network logic below; you only call the generated client's methods.
// Check the generated file for the exact method/record names in your
// Ballerina version — they should match the pattern shown here, but
// confirm before you copy-paste.

import ballerina/io;
// import rental_accommodation.server.rental_pb; // <- adjust to wherever
                                                   //    your generated stub
                                                   //    module ends up

public function main() returns error? {

    // rental_pb:RentalServiceClient rentalClient = check new ("http://localhost:9090");

    // =====================================================================
    // WORKED EXAMPLE — add_property (simple RPC)
    // Use this as the pattern for every other call below.
    // =====================================================================

    // rental_pb:PropertyRequest newProperty = {
    //     hostId: "HOST-01",
    //     name: "Seaside Cottage",
    //     location: "Swakopmund",
    //     propertyType: "Cottage",
    //     pricePerNight: 850.00,
    //     status: "AVAILABLE"
    // };
    // rental_pb:PropertyResponse addResp = check rentalClient->addProperty(newProperty);
    // io:println("Added property: ", addResp);

    // =====================================================================
    // TODO — create_users (client-side streaming)
    // Pattern:
    //   var userStream = check rentalClient->createUsers();
    //   foreach var u in yourUserList {
    //       check userStream->sendUserRequest(u);
    //   }
    //   rental_pb:CreateUsersResponse resp = check userStream->complete();
    //   io:println(resp);
    // =====================================================================

    // =====================================================================
    // TODO — update_property (simple RPC)
    // Same pattern as add_property: build an UpdatePropertyRequest,
    // call rentalClient->updateProperty(req), print the PropertyResponse.
    // =====================================================================

    // =====================================================================
    // TODO — remove_property (simple RPC)
    // Build a RemovePropertyRequest, call rentalClient->removeProperty(req),
    // print the returned PropertyListResponse (the host's remaining listings).
    // =====================================================================

    // =====================================================================
    // TODO — list_available_properties (server-side streaming)
    // Pattern:
    //   stream<rental_pb:PropertyResponse, error?> results =
    //       check rentalClient->listAvailableProperties({location: "", maxPrice: 0.0});
    //   check results.forEach(function(rental_pb:PropertyResponse p) {
    //       io:println(p);
    //   });
    // =====================================================================

    // =====================================================================
    // TODO — search_property (simple RPC)
    // Build a SearchPropertyRequest, call rentalClient->searchProperty(req).
    // =====================================================================

    // =====================================================================
    // TODO — book_property (simple RPC)
    // Build a BookingRequest (guestId, propertyId, checkIn, checkOut),
    // call rentalClient->bookProperty(req), keep the returned bookingRef.
    // =====================================================================

    // =====================================================================
    // TODO — confirm_booking (simple RPC)
    // Build a ConfirmBookingRequest with the bookingRef from above,
    // call rentalClient->confirmBooking(req), print the BookingConfirmation.
    // =====================================================================

    io:println("Fill in the calls above once the gRPC stubs are generated.");
}
