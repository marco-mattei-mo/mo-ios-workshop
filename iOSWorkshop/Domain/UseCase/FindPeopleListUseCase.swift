class FindPeopleListUseCase {
    private let peopleRepository: PeopleRepository

    init(peopleRepository: PeopleRepository) {
        self.peopleRepository = peopleRepository
    }

    func execute() async throws -> [People] {
        //TODO: Part 4 - Call the repository function to find the people list and return its value
    }
}
