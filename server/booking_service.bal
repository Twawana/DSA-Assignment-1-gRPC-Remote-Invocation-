// booking_service.bal
// Business logic for: book_property, confirm_booking.
//
// Marks: contributes to "gRPC Server Implementation" (25 marks) —
// this is the part the rubric weighs most heavily ("comprehensive
// server-side logic handling data persistence, validation, and price
// calculation"), so give the TODOs below real attention.

import ballerina/time;

public function bookProperty(string guestId, string propertyId,
        string checkIn, string checkOut) returns PendingBooking|error {

    // TODO 1: verify propertyId exists in propertyStore (else error).
    // TODO 2: validate checkOut is strictly after checkIn.
    //         Parse "YYYY-MM-DD" with time:civilFromString / time:utcFromString,
    //         or split the string and compare year/month/day as a simpler
    //         approach if you haven't covered ballerina/time yet.
    // TODO 3: create a PendingBooking with nextBookingRef(), store it in
    //         pendingBookings, and return it.

    return error("Not implemented: bookProperty");
}

public function confirmBooking(string bookingRef) returns ConfirmedBooking|error {

    // TODO 1: look up pendingBookings[bookingRef]; error if missing.
    // TODO 2: look up the property in propertyStore for its pricePerNight.
    // TODO 3: check for date overlaps: loop over confirmedBookings for the
    //         same propertyId and reject if [checkIn, checkOut) overlaps
    //         any existing confirmed range for that property.
    // TODO 4: calculate nights (checkOut - checkIn) and
    //         totalCost = nights * pricePerNight.
    // TODO 5: build a ConfirmedBooking, store it in confirmedBookings,
    //         remove the entry from pendingBookings, and return it.

    return error("Not implemented: confirmBooking");
}

// Optional helper — you'll likely want something like this for both
// TODO 2 above and the overlap check in TODO 3.
function daysBetween(string isoDateA, string isoDateB) returns int|error {
    // TODO: parse both "YYYY-MM-DD" strings and return the difference
    // in days (isoDateB - isoDateA). ballerina/time's civil records and
    // time:utcFromCivil / time:utcDiffSeconds are one way to do this.
    return error("Not implemented: daysBetween");
}
