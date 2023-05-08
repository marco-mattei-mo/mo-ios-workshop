struct DefaultPeopleRepository: PeopleRepository {
    let peopleDataSource: PeopleDataSource
    
    func findPeopleList() async throws -> [People] {
        // Part 3 - Call the datasource function to find the people list and convert the data to match the return type
        try await peopleDataSource.findPeopleList().compactMap { $0.toDomain() }
    }
       
}
