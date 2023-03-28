struct PeopleDIContainer {
    // Fakes
    static func makeFakeFindPeopleListUseCase() -> FindPeopleListUseCase {
        FindPeopleListUseCase(peopleRepository: DefaultPeopleRepository(peopleDataSource: FakePeopleDataSource()))
    }
    
    static func makeFakePeopleListViewModel() -> PeopleListViewModel {
        PeopleListViewModel(findPeopleListUseCase: makeFakeFindPeopleListUseCase())
    }

    
    // Network
    static func makeFindPeopleListUseCase() -> FindPeopleListUseCase {
        FindPeopleListUseCase(peopleRepository: DefaultPeopleRepository(peopleDataSource: NetworkPeopleDataSource()))
    }
    
    static func makePeopleListViewModel() -> PeopleListViewModel {
        PeopleListViewModel(findPeopleListUseCase: makeFindPeopleListUseCase())
    }
}
