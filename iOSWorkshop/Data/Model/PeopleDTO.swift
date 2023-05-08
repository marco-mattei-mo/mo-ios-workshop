struct PeopleDTO: Codable {
    // Part 1 - Write the PeopleDTO struct according to the data model. Required fields are defined in the "People" domain object
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case height = "height"
        case mass = "mass"
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender = "gender"
    }
}

extension PeopleDTO {
    func toDomain() -> People? {
        // Part 1 - Convert the DTO to the domain model
        let height = Int(height)
        let mass = Int(mass)
        guard let height, let mass else { return nil }
        
        return People(name: name,
                      height: height,
                      mass: mass,
                      hairColor: hairColor,
                      skinColor: skinColor,
                      eyeColor: eyeColor,
                      birthYear: birthYear,
                      gender: gender)
    }
}
