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

class FindPeopleListUseCaseTest: XCTestCase {
    
    private var repository: PeopleRepositoryMock!
    private var useCase: FindPeopleListUseCase!
    private var faker = Faker()
    
    override func setUp() {
        super.setUp()
        repository = mock(PeopleRepository.self)
        useCase = FindPeopleListUseCase(peopleRepository: repository)
    }
    
    private func generatePeople() -> People {
        People(name: faker.name.name(),
               height: faker.number.randomInt(min: 150, max: 210),
               mass: faker.number.randomInt(min: 40, max: 120),
               hairColor: faker.commerce.color(),
               skinColor: faker.commerce.color(),
               eyeColor: faker.commerce.color(),
               birthYear: "\(faker.number.randomInt(min: 0, max: 1000))BBY",
               gender: faker.gender.type())
    }
    
    func testFindPeopleListUseCaseSuccess() async {
        // Given
        let testPeopleList = [generatePeople(), generatePeople()]
        given(await repository.findPeopleList()).willReturn(testPeopleList)
        
        // When
        let peopleList = try? await useCase.execute()
        
        // Then
        verify(await repository.findPeopleList()).wasCalled(once)
        XCTAssertNotNil(peopleList)
        XCTAssertTrue(peopleList!.elementsEqual(testPeopleList))
    }
    
    func testFindPeopleListUseCaseFailure() async {
        // Given
        givenSwift(await repository.findPeopleList()).will { throw PeopleError.unknown }
        
        // When
        var sutError: Error?
        do {
            _ = try await useCase.execute()
        } catch {
            sutError = error
        }
        
        // Then
        verify(await repository.findPeopleList()).wasCalled(once)
        XCTAssertNotNil(sutError)
        XCTAssertEqual(sutError as? PeopleError, .unknown)
    }
}
