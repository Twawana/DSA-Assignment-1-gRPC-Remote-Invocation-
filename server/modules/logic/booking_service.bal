// booking_service.bal
// Business logic for: book_property, confirm_booking.

import ballerina/time;

public function bookProperty(string guestId, string propertyId,
        string checkIn, string checkOut) returns PendingBooking|error {

    PropertyRecord? prop = propertyStore[propertyId];
    if prop is () {
        return error("Property not found: " + propertyId);
    }

    if checkOut <= checkIn {
        return error("checkOut must be after checkIn");
    }

    string ref = nextBookingRef();
    PendingBooking booking = {
        bookingRef: ref,
        guestId: guestId,
        propertyId: propertyId,
        checkIn: checkIn,
        checkOut: checkOut
    };

    pendingBookings[ref] = booking;
    return booking;
}

public function confirmBooking(string bookingRef) returns ConfirmedBooking|error {

    PendingBooking? pending = pendingBookings[bookingRef];
    if pending is () {
        return error("Booking not found: " + bookingRef);
    }

    PropertyRecord? prop = propertyStore[pending.propertyId];
    if prop is () {
        return error("Property no longer exists: " + pending.propertyId);
    }

    foreach ConfirmedBooking existing in confirmedBookings {
        if existing.propertyId == pending.propertyId {
            boolean overlaps = pending.checkIn < existing.checkOut &&
                    existing.checkIn < pending.checkOut;
            if overlaps {
                return error("Dates overlap with an existing confirmed booking: " + existing.bookingRef);
            }
        }
    }

    int nights = check daysBetween(pending.checkIn, pending.checkOut);
    decimal totalCost = <decimal>nights * prop.pricePerNight;

    ConfirmedBooking confirmed = {
        bookingRef: pending.bookingRef,
        guestId: pending.guestId,
        propertyId: pending.propertyId,
        checkIn: pending.checkIn,
        checkOut: pending.checkOut,
        totalCost: totalCost,
        nights: nights
    };

    confirmedBookings[bookingRef] = confirmed;
    _ = pendingBookings.remove(bookingRef);

    return confirmed;
}

function daysBetween(string isoDateA, string isoDateB) returns int|error {
    time:Civil a = check time:civilFromString(isoDateA + "T00:00:00.00Z");
    time:Civil b = check time:civilFromString(isoDateB + "T00:00:00.00Z");
    time:Utc utcA = check time:utcFromCivil(a);
    time:Utc utcB = check time:utcFromCivil(b);
    decimal diffSeconds = time:utcDiffSeconds(utcB, utcA);
    return <int>(diffSeconds / 86400);
}