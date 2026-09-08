import ballerina/grpc;
import rental_accommodation/server as srv;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: RENTAL_DESC}
service "RentalService" on ep {

    remote function AddProperty(PropertyRequest value) returns PropertyResponse|error {
    }

    remote function UpdateProperty(UpdatePropertyRequest value) returns PropertyResponse|error {
    }

    remote function RemoveProperty(RemovePropertyRequest value) returns PropertyListResponse|error {
    }

    remote function SearchProperty(SearchPropertyRequest value) returns PropertyResponse|error {
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
    }

    remote function ListAvailableProperties(ListPropertiesRequest value) returns stream<PropertyResponse, error?>|error {
    }
}