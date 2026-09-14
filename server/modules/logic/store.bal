// store.bal
// In-memory data layer for the Rental Accommodation System.
// Uses Ballerina maps as the "database" per the assignment spec.
// This file is complete — plug your logic in property_service.bal,
// booking_service.bal and users_service.bal on top of it.

public type PropertyRecord record {|
    string propertyId;
    string hostId;
    string name;
    string location;
    string propertyType;
    decimal pricePerNight;
    string status; // AVAILABLE, BOOKED, UNAVAILABLE
|};

public type UserRecord record {|
    string userId;
    string name;
    string role; // HOST or GUEST
    string email;
|};

// A booking that has been requested but not yet confirmed ("booking cart").
public type PendingBooking record {|
    string bookingRef;
    string guestId;
    string propertyId;
    string checkIn;  // "YYYY-MM-DD"
    string checkOut; // "YYYY-MM-DD"
|};

public type ConfirmedBooking record {|
    string bookingRef;
    string guestId;
    string propertyId;
    string checkIn;
    string checkOut;
    decimal totalCost;
    int nights;
|};

// ------------------------ In-memory "tables" ------------------------

public map<PropertyRecord> propertyStore = {};
public map<UserRecord> userStore = {};
public map<PendingBooking> pendingBookings = {};       // keyed by bookingRef
public map<ConfirmedBooking> confirmedBookings = {};   // keyed by bookingRef

// ------------------------- ID generators -----------------------------

int propertyCounter = 0;
int bookingCounter = 0;

public function nextPropertyId() returns string {
    lock {
        propertyCounter += 1;
        return "PROP-" + propertyCounter.toString();
    }
}

public function nextBookingRef() returns string {
    lock {
        bookingCounter += 1;
        return "BK-" + bookingCounter.toString();
    }
}
