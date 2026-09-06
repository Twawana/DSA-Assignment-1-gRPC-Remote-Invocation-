import ballerina/grpc;

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
    }

    remote function ListAvailableProperties(ListPropertiesRequest value) returns stream<PropertyResponse, error?>|error {
    }
}
