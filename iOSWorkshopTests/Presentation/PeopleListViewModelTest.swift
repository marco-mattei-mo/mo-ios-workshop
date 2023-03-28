//
//  PeopleListViewModelTest.swift
//  iOSWorkshopTests
//
//  Created by Mattei, Marco-MIGROSONLINE on 27.03.23.
//

@testable import iOSWorkshop
import Combine
import Fakery
import Mockingbird
import XCTest

class PeopleListViewModelTest: XCTestCase {
    
    private var findPeopleListUseCase: FindPeopleListUseCaseMock!
    private var repository: PeopleRepository!
    private var faker = Faker()
    
    override func setUp() {
        super.setUp()
        repository = DefaultPeopleRepository(peopleDataSource: NetworkPeopleDataSource())
        findPeopleListUseCase = mock(FindPeopleListUseCase.self).initialize(peopleRepository: repository)
    }
    
    private func generatePeople(name: String? = nil, height: Int? = nil) -> People {
        People(name: name ?? faker.name.name(),
               height: height ?? faker.number.randomInt(min: 150, max: 210),
               mass: faker.number.randomInt(min: 40, max: 120),
               hairColor: faker.commerce.color(),
               skinColor: faker.commerce.color(),
               eyeColor: faker.commerce.color(),
               birthYear: "\(faker.number.randomInt(min: 0, max: 1000))BBY",
               gender: faker.gender.type())
    }

    func testLoadPeopleListSuccess() async {
        // Given
        let peopleList = [generatePeople()]
        let viewModel = PeopleListViewModel(findPeopleListUseCase: findPeopleListUseCase)
        given(await findPeopleListUseCase.execute()).willReturn(peopleList)
        
        // When
        await viewModel.loadPeopleList()
        
        // Then
        verify(await findPeopleListUseCase.execute()).wasCalled(once)
        XCTAssertEqual(viewModel.people.count, 1)
        XCTAssertTrue(viewModel.people.elementsEqual(peopleList))
    }
    
    func testLoadPeopleListSuccessSortsBySelectedSorting() async {
        // Given
        let peopleList = [generatePeople(name: "Obi-wan"), generatePeople(name: "Anakin")]
        let viewModel = PeopleListViewModel(findPeopleListUseCase: findPeopleListUseCase)
        given(await findPeopleListUseCase.execute()).willReturn(peopleList)
        viewModel.sortBy = .name
        
        // When
        await viewModel.loadPeopleList()
        
        // Then
        verify(await findPeopleListUseCase.execute()).wasCalled(once)
        XCTAssertEqual(viewModel.people.count, 2)
        XCTAssertTrue(viewModel.people.elementsEqual([peopleList[1], peopleList[0]]))
    }
    
    func testLoadPeopleListError() async {
        // Given
        let viewModel = PeopleListViewModel(findPeopleListUseCase: findPeopleListUseCase)
        givenSwift(await findPeopleListUseCase.execute()).will { throw PeopleError.unknown }
        
        // When
        await viewModel.loadPeopleList()
        
        // Then
        verify(await findPeopleListUseCase.execute()).wasCalled(once)
        XCTAssertEqual(viewModel.loadError, String(describing: PeopleError.unknown))
    }
    
    func testInitSetsUpTheStoreBySubscriber() async {
        // Given
        let peopleList = [generatePeople(name: "Anakin", height: 190), generatePeople(name: "Obi-wan", height: 180)] // He has the high ground 😮
        let viewModel = PeopleListViewModel(findPeopleListUseCase: findPeopleListUseCase)
        given(await findPeopleListUseCase.execute()).willReturn(peopleList)
        
        var cancellables = Set<AnyCancellable>()
        let expectation = XCTestExpectation(description: "Receive the 'sort by height'")
        
        viewModel.$sortBy
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0, .height)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // When
        await viewModel.loadPeopleList()
        viewModel.sortBy = .height
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(viewModel.people.count, 2)
        XCTAssertTrue(viewModel.people.elementsEqual([peopleList[1], peopleList[0]]))
    }
}
