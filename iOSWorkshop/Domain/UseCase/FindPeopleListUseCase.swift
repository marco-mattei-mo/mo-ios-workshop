class FindPeopleListUseCase {
    private let peopleRepository: PeopleRepository

    init(peopleRepository: PeopleRepository) {
        self.peopleRepository = peopleRepository
    }

    func execute() async throws -> [People] {
        try await peopleRepository.findPeopleList()
    }
}
