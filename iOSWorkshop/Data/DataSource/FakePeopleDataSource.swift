import Fakery

struct FakePeopleDataSource: PeopleDataSource {
    let faker = Faker()
    
    func findPeopleList() async throws -> [PeopleDTO] {
        var peopleList: [PeopleDTO] = []
        for _ in 1...Int.random(in: 1..<50) {
            peopleList.append(generatePeople())
        }
        return peopleList
    }
    
    private func generatePeople() -> PeopleDTO {
        return PeopleDTO(name: faker.name.name(), height: String(faker.number.randomInt(min: 150, max: 210)), mass: String(faker.number.randomInt(min: 40, max: 120)), hairColor: faker.commerce.color(), skinColor: faker.commerce.color(), eyeColor: faker.commerce.color(), birthYear: "\(faker.number.randomInt(min: 0, max: 1000))BBY", gender: faker.gender.type())
    }
}
