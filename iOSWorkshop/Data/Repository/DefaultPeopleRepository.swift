struct DefaultPeopleRepository: PeopleRepository {
    let peopleDataSource: PeopleDataSource
    
    func findPeopleList() async throws -> [People] {
        try await peopleDataSource.findPeopleList().compactMap { $0.toDomain() }
    }
       
}
