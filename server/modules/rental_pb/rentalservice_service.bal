import ballerina/grpc;
import rental_accommodation/server as app;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: RENTAL_DESC}
service "RentalService" on ep {

    remote function AddProperty(PropertyRequest value) returns PropertyResponse|error {
        app:PropertyRecord|error result = app:addProperty(value.host_id, value.name,
            value.location, value.property_type, <decimal>value.price_per_night,
            value.status);
        if result is error {
            return {success: false, message: result.message()};
        }
        return {success: true, message: "Property added",
            property: toProperty(result)};
    }

    remote function UpdateProperty(UpdatePropertyRequest value) returns PropertyResponse|error {
        decimal? price = value.price_per_night == 0.0 ? () :
            <decimal>value.price_per_night;
        string? status = value.status == "" ? () : value.status;
        app:PropertyRecord|error result = app:updateProperty(value.property_id, price, status);
        if result is error {
            return {success: false, message: result.message()};
        }
        return {success: true, message: "Property updated",
            property: toProperty(result)};
    }

    remote function RemoveProperty(RemovePropertyRequest value) returns PropertyListResponse|error {
        app:PropertyRecord[]|error result = app:removeProperty(value.property_id, value.host_id);
        if result is error {
            return {success: false, message: result.message()};
        }
        return {success: true, message: "Property removed",
            properties: fromProperties(result)};
    }

    remote function SearchProperty(SearchPropertyRequest value) returns PropertyResponse|error {
        app:PropertyRecord|error result = app:searchProperty(value.property_id);
        if result is error {
            return {success: false, message: result.message()};
        }
        return {success: true, message: "Property found",
            property: toProperty(result)};
    }

    remote function BookProperty(BookingRequest value) returns BookingResponse|error {
        app:PendingBooking|error result = app:bookProperty(value.guest_id, value.property_id,
            value.check_in, value.check_out);
        if result is error {
            return {success: false, message: result.message()};
        }
        return {success: true, message: "Booking requested",
            booking_ref: result.bookingRef};
    }

    remote function ConfirmBooking(ConfirmBookingRequest value) returns BookingConfirmation|error {
        app:ConfirmedBooking|error result = app:confirmBooking(value.booking_ref);
        if result is error {
            return {success: false, message: result.message()};
        }
        return {success: true, message: "Booking confirmed",
            booking_ref: result.bookingRef, total_cost: <float>result.totalCost,
            nights: result.nights};
    }

    remote function CreateUsers(stream<UserRequest, grpc:Error?> clientStream) returns CreateUsersResponse|error {
        int count = 0;
        while true {
            record {|UserRequest value;|}|grpc:Error? next = clientStream.next();
            if next is () {
                break;
            }
            if next is grpc:Error {
                return next;
            }
            error? result = app:registerUser(next.value.user_id, next.value.name,
                next.value.role, next.value.email);
            if result is error {
                return {success: false, count: count, message: result.message()};
            }
            count += 1;
        }
        return {success: true, count: count, message: "Users created"};
    }

    remote function ListAvailableProperties(ListPropertiesRequest value) returns stream<PropertyResponse, error?>|error {
        app:PropertyRecord[] properties = app:listAvailableProperties(
            value.location == "" ? () : value.location,
            value.max_price == 0.0 ? () : <decimal>value.max_price);
        return stream from app:PropertyRecord property in properties
            select {success: true, message: "Property found",
                property: toProperty(property)};
    }
}

function toProperty(app:PropertyRecord value) returns Property {
    return {property_id: value.propertyId, host_id: value.hostId,
        name: value.name, location: value.location,
        property_type: value.propertyType, price_per_night: <float>value.pricePerNight,
        status: value.status};
}

function fromProperties(app:PropertyRecord[] values) returns Property[] {
    Property[] properties = [];
    foreach app:PropertyRecord value in values {
        properties.push(toProperty(value));
    }
    return properties;
}
