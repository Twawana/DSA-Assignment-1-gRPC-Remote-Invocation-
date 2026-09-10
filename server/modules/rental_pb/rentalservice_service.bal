import ballerina/grpc;
import rental_accommodation/server;

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
    }

    remote function ConfirmBooking(ConfirmBookingRequest value) returns BookingConfirmation|error {
    }

    remote function CreateUsers(stream<UserRequest, grpc:Error?> clientStream) returns CreateUsersResponse|error {
        int successCount = 0;

        while true {
            record {|UserRequest value;|}|grpc:Error? next = clientStream.next();

            if next is () {
                break;
            }

            if next is grpc:Error {
                return next;
            }

            UserRequest userReq = next.value;
            error? result = server:registerUser(userReq.user_id, userReq.name, userReq.role, userReq.email);

            if result is () {
                successCount += 1;
            }
        }

        return {
            success: true,
            count: successCount,
            message: "Registered " + successCount.toString() + " user(s)."
        };
    }

    remote function ListAvailableProperties(ListPropertiesRequest value) returns stream<PropertyResponse, error?>|error {
    }
}