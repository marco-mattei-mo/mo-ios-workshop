protocol PeopleDataSource {
    func findPeopleList() async throws -> [PeopleDTO]
}
