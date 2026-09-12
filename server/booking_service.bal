// booking_service.bal
// Business logic for: book_property, confirm_booking.
//
// Marks: contributes to "gRPC Server Implementation" (25 marks) —
// this is the part the rubric weighs most heavily ("comprehensive
// server-side logic handling data persistence, validation, and price
// calculation"), so give the TODOs below real attention.

public function bookProperty(string guestId, string propertyId,
        string checkIn, string checkOut) returns PendingBooking|error {
    if guestId.trim() == "" {
        return error("Invalid guest: guest ID is required");
    }
    if propertyId.trim() == "" {
        return error("Invalid property: property ID is required");
    }

    PropertyRecord? property = propertyStore[propertyId];
    if property is () {
        return error("Property not found: " + propertyId);
    }
    if property.status != "AVAILABLE" {
        return error("Property unavailable: " + propertyId);
    }

    int nights = check daysBetween(checkIn, checkOut);
    if nights <= 0 {
        return error("Invalid dates: check-in must be before check-out");
    }

    foreach string bookingRef in pendingBookings.keys() {
        PendingBooking? existing = pendingBookings[bookingRef];
        if existing is PendingBooking && existing.propertyId == propertyId &&
            check rangesOverlap(existing.checkIn, existing.checkOut,
            checkIn, checkOut) {
            return error("Booking overlaps an existing pending booking");
        }
    }

    foreach string bookingRef in confirmedBookings.keys() {
        ConfirmedBooking? existing = confirmedBookings[bookingRef];
        if existing is ConfirmedBooking && existing.propertyId == propertyId &&
            check rangesOverlap(existing.checkIn, existing.checkOut,
            checkIn, checkOut) {
            return error("Booking overlaps an existing confirmed booking");
        }
    }

    PendingBooking booking = {
        bookingRef: nextBookingRef(),
        guestId: guestId,
        propertyId: propertyId,
        checkIn: checkIn,
        checkOut: checkOut
    };
    pendingBookings[booking.bookingRef] = booking;
    return booking;
}

public function confirmBooking(string bookingRef) returns ConfirmedBooking|error {
    PendingBooking? pending = pendingBookings[bookingRef];
    if pending is () {
        return error("Booking not found: " + bookingRef);
    }

    PropertyRecord? property = propertyStore[pending.propertyId];
    if property is () {
        return error("Property not found: " + pending.propertyId);
    }
    if property.status != "AVAILABLE" {
        return error("Property unavailable: " + pending.propertyId);
    }

    int nights = check daysBetween(pending.checkIn, pending.checkOut);
    if nights <= 0 {
        return error("Invalid dates: check-in must be before check-out");
    }

    foreach string existingRef in confirmedBookings.keys() {
        ConfirmedBooking? existing = confirmedBookings[existingRef];
        if existing is ConfirmedBooking && existing.propertyId == pending.propertyId
                && check rangesOverlap(existing.checkIn, existing.checkOut,
                pending.checkIn, pending.checkOut) {
            return error("Booking overlaps an existing confirmed booking");
        }
    }

    ConfirmedBooking confirmed = {
        bookingRef: pending.bookingRef,
        guestId: pending.guestId,
        propertyId: pending.propertyId,
        checkIn: pending.checkIn,
        checkOut: pending.checkOut,
        totalCost: property.pricePerNight * <decimal>nights,
        nights: nights
    };
    confirmedBookings[bookingRef] = confirmed;
    _ = pendingBookings.remove(bookingRef);
    return confirmed;
}

function daysBetween(string isoDateA, string isoDateB) returns int|error {
    int[] dateA = check parseDate(isoDateA);
    int[] dateB = check parseDate(isoDateB);
    return dateOrdinal(dateB[0], dateB[1], dateB[2]) -
        dateOrdinal(dateA[0], dateA[1], dateA[2]);
}

function rangesOverlap(string firstCheckIn, string firstCheckOut,
        string secondCheckIn, string secondCheckOut) returns boolean|error {
    int firstStartToSecondEnd = check daysBetween(firstCheckIn, secondCheckOut);
    int secondStartToFirstEnd = check daysBetween(secondCheckIn, firstCheckOut);
    return firstStartToSecondEnd > 0 && secondStartToFirstEnd > 0;
}

function parseDate(string value) returns int[]|error {
    if value.length() != 10 {
        return error("Invalid date: expected YYYY-MM-DD");
    }

    if value.substring(4, 5) != "-" || value.substring(7, 8) != "-" {
        return error("Invalid date: expected YYYY-MM-DD");
    }

    int year = check int:fromString(value.substring(0, 4));
    int month = check int:fromString(value.substring(5, 7));
    int day = check int:fromString(value.substring(8, 10));
    if year < 1 || month < 1 || month > 12 {
        return error("Invalid date: " + value);
    }

    int[] monthLengths = [31, isLeapYear(year) ? 29 : 28, 31, 30, 31, 30,
        31, 31, 30, 31, 30, 31];
    if day < 1 || day > monthLengths[month - 1] {
        return error("Invalid date: " + value);
    }
    return [year, month, day];
}

function isLeapYear(int year) returns boolean {
    return year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
}

function dateOrdinal(int year, int month, int day) returns int {
    int completedYears = year - 1;
    int days = completedYears * 365 + completedYears / 4 -
        completedYears / 100 + completedYears / 400;
    int[] monthLengths = [31, isLeapYear(year) ? 29 : 28, 31, 30, 31, 30,
        31, 31, 30, 31, 30, 31];
    int monthIndex = 0;
    while monthIndex < month - 1 {
        days += monthLengths[monthIndex];
        monthIndex += 1;
    }
    return days + day;
}
