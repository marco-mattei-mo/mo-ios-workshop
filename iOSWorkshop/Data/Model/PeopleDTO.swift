struct PeopleDTO: Codable {
    //TODO: Part 1 - Write the PeopleDTO struct according to the data model. Required fields are defined in the "People" domain object
}

extension PeopleDTO {
    func toDomain() -> People? {
        // TODO: Part 1 - Convert the DTO to the domain model
        // ⚠️ If the conversion of the "height" or "width" attributes to Int fail, return nil
        return nil
    }
}
