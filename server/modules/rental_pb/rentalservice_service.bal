import ballerina/grpc;
import rental_accommodation/server.logic as srv;

listener grpc:Listener ep = new (9090);

function toProtoProperty(srv:PropertyRecord p) returns Property {
    return {
        property_id: p.propertyId,
        host_id: p.hostId,
        name: p.name,
        location: p.location,
        property_type: p.propertyType,
        price_per_night: <float>p.pricePerNight,
        status: p.status
    };
}

@grpc:Descriptor {value: RENTAL_DESC}
service "RentalService" on ep {

    remote function AddProperty(PropertyRequest value) returns PropertyResponse|error {
        srv:PropertyRecord|error result = srv:addProperty(value.host_id, value.name, value.location,
                value.property_type, <decimal>value.price_per_night, value.status);
        if result is error {
            return { success: false, message: result.message(), property: {} };
        }
        return { success: true, message: "Property added", property: toProtoProperty(result) };
    }

    remote function UpdateProperty(UpdatePropertyRequest value) returns PropertyResponse|error {
        decimal? newPrice = value.price_per_night > 0.0 ? <decimal>value.price_per_night : ();
        string? newStatus = value.status == "" ? () : value.status;
        srv:PropertyRecord|error result = srv:updateProperty(value.property_id, newPrice, newStatus);
        if result is error {
            return { success: false, message: result.message(), property: {} };
        }
        return { success: true, message: "Property updated", property: toProtoProperty(result) };
    }

    remote function RemoveProperty(RemovePropertyRequest value) returns PropertyListResponse|error {
        srv:PropertyRecord[]|error result = srv:removeProperty(value.property_id, value.host_id);
        if result is error {
            return { success: false, message: result.message(), properties: [] };
        }
        Property[] remaining = from srv:PropertyRecord p in result select toProtoProperty(p);
        return { success: true, message: "Property removed", properties: remaining };
    }

    remote function SearchProperty(SearchPropertyRequest value) returns PropertyResponse|error {
        srv:PropertyRecord|error result = srv:searchProperty(value.property_id);
        if result is error {
            return { success: false, message: result.message(), property: {} };
        }
        return { success: true, message: "Property found", property: toProtoProperty(result) };
    }

    remote function BookProperty(BookingRequest value) returns BookingResponse|error {
        srv:PendingBooking|error result = srv:bookProperty(value.guest_id, value.property_id,
                value.check_in, value.check_out);
        if result is error {
            return { success: false, message: result.message(), booking_ref: "" };
        }
        return { success: true, message: "Booking request received", booking_ref: result.bookingRef };
    }

    remote function ConfirmBooking(ConfirmBookingRequest value) returns BookingConfirmation|error {
        srv:ConfirmedBooking|error result = srv:confirmBooking(value.booking_ref);
        if result is error {
            return { success: false, message: result.message(), booking_ref: value.booking_ref,
                      total_cost: 0.0, nights: 0 };
        }
        return {
            success: true,
            message: "Booking confirmed",
            booking_ref: result.bookingRef,
            total_cost: <float>result.totalCost,
            nights: result.nights
        };
    }

    remote function CreateUsers(stream<UserRequest, grpc:Error?> clientStream) returns CreateUsersResponse|error {
        int successCount = 0;
        int failCount = 0;

        error? streamError = clientStream.forEach(function(UserRequest req) {
            error? result = srv:registerUser(req.user_id, req.name, req.role, req.email);
            if result is error {
                failCount += 1;
            } else {
                successCount += 1;
            }
        });

        if streamError is error {
            return streamError;
        }

        return {
            success: failCount == 0,
            count: successCount,
            message: failCount == 0
                ? "All users registered successfully"
                : successCount.toString() + " registered, " + failCount.toString() + " rejected"
        };
    }

    remote function ListAvailableProperties(ListPropertiesRequest value) returns stream<PropertyResponse, error?>|error {
        string? location = value.location == "" ? () : value.location;
        decimal? maxPrice = value.max_price > 0.0 ? <decimal>value.max_price : ();
        srv:PropertyRecord[] results = srv:listAvailableProperties(location, maxPrice);

        stream<PropertyResponse, error?> responseStream = stream from srv:PropertyRecord p in results
            select { success: true, message: "", property: toProtoProperty(p) };

        return responseStream;
    }
}