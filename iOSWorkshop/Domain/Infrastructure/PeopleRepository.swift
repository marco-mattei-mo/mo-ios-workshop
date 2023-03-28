protocol PeopleRepository {
    func findPeopleList() async throws -> [People]
}
