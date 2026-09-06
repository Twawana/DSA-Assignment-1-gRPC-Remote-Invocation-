// property_service.bal
// Business logic for: add_property, update_property, remove_property,
// list_available_properties, search_property.
//
// These are plain Ballerina functions — no gRPC types here on purpose,
// so this file compiles and can be unit-tested independently of the
// generated gRPC stubs. Wire these into the generated service's remote
// functions (see README.md "Wiring the generated service").
//
// Marks: contributes to "gRPC Server Implementation" (25 marks).

public function addProperty(string hostId, string name, string location,
        string propertyType, decimal pricePerNight, string status)
        returns PropertyRecord|error {

    // TODO 1: validate inputs — e.g. name/location/hostId not empty,
    //         pricePerNight > 0d, status is one of the allowed values.
    // TODO 2: generate a unique id with nextPropertyId().
    // TODO 3: build a PropertyRecord and store it in propertyStore
    //         (propertyStore[id] = record).
    // TODO 4: return the created PropertyRecord.

    return error("Not implemented: addProperty");
}

public function updateProperty(string propertyId, decimal? newPrice, string? newStatus)
        returns PropertyRecord|error {

    // TODO 1: look up propertyStore[propertyId]; if it doesn't exist,
    //         return error("Property not found: " + propertyId).
    // TODO 2: apply newPrice / newStatus only if they were provided
    //         (they are `?` — optional — so check `is ()` first).
    // TODO 3: save the updated record back into propertyStore.
    // TODO 4: return the updated record.

    return error("Not implemented: updateProperty");
}

public function removeProperty(string propertyId, string hostId)
        returns PropertyRecord[]|error {

    // TODO 1: verify propertyStore has propertyId, and (optionally)
    //         that its hostId matches the caller's hostId.
    // TODO 2: remove it from propertyStore, e.g. `_ = propertyStore.remove(propertyId);`
    // TODO 3: build and return the list of that host's remaining
    //         properties (filter propertyStore.toArray() by hostId).

    return error("Not implemented: removeProperty");
}

public function listAvailableProperties(string? location, decimal? maxPrice)
        returns PropertyRecord[] {

    // TODO: return propertyStore values where:
    //   - status == "AVAILABLE"
    //   - location is () OR p.location == location
    //   - maxPrice is () OR p.pricePerNight <= maxPrice
    // Tip: propertyStore.toArray() gives you PropertyRecord[] to filter.

    return [];
}

public function searchProperty(string propertyId) returns PropertyRecord|error {
    // TODO: look up propertyStore[propertyId].
    //       If missing, return error("Not Available") — the spec
    //       explicitly asks for this exact case to be handled.

    return error("Not Available");
}
