// property_service.bal

final string[] VALID_STATUSES = ["AVAILABLE", "BOOKED", "UNAVAILABLE"];

public function addProperty(string hostId, string name, string location,
        string propertyType, decimal pricePerNight, string status)
        returns PropertyRecord|error {

    if hostId.trim() == "" || name.trim() == "" || location.trim() == "" {
        return error("hostId, name, and location are required");
    }
    if pricePerNight <= 0d {
        return error("pricePerNight must be greater than 0");
    }
    if VALID_STATUSES.indexOf(status) is () {
        return error("Invalid status: " + status);
    }

    string id = nextPropertyId();
    PropertyRecord property = {
        propertyId: id,
        hostId: hostId,
        name: name,
        location: location,
        propertyType: propertyType,
        pricePerNight: pricePerNight,
        status: status
    };

    propertyStore[id] = property;
    return property;
}

public function updateProperty(string propertyId, decimal? newPrice, string? newStatus)
        returns PropertyRecord|error {

    PropertyRecord? existing = propertyStore[propertyId];
    if existing is () {
        return error("Property not found: " + propertyId);
    }

    PropertyRecord updated = existing;

    if newPrice is decimal {
        if newPrice <= 0d {
            return error("pricePerNight must be greater than 0");
        }
        updated.pricePerNight = newPrice;
    }

    if newStatus is string {
        if VALID_STATUSES.indexOf(newStatus) is () {
            return error("Invalid status: " + newStatus);
        }
        updated.status = newStatus;
    }

    propertyStore[propertyId] = updated;
    return updated;
}

public function removeProperty(string propertyId, string hostId)
        returns PropertyRecord[]|error {

    PropertyRecord? existing = propertyStore[propertyId];
    if existing is () {
        return error("Property not found: " + propertyId);
    }
    if existing.hostId != hostId {
        return error("Property does not belong to host: " + hostId);
    }

    _ = propertyStore.remove(propertyId);

    return from PropertyRecord p in propertyStore
        where p.hostId == hostId
        where p.status == "AVAILABLE"
        select p;
}

public function listAvailableProperties(string? location, decimal? maxPrice)
        returns PropertyRecord[] {

    return from PropertyRecord p in propertyStore
        where p.status == "AVAILABLE"
        where location is () || location == "" || p.location == location
        where maxPrice is () || maxPrice == 0d || p.pricePerNight <= maxPrice
        select p;
}

public function searchProperty(string propertyId) returns PropertyRecord|error {
    PropertyRecord? found = propertyStore[propertyId];
    if found is () {
        return error("Not Available");
    }
    return found;
}