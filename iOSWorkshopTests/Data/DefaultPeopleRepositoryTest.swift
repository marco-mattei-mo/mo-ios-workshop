//
//  DefaultPeopleRepositoryTest.swift
//  iOSWorkshopTests
//
//  Created by Mattei, Marco-MIGROSONLINE on 27.03.23.
//

@testable import iOSWorkshop
import Combine
import Fakery
import Mockingbird
import XCTest

class DefaultPeopleRepositoryTest: XCTestCase {
    
    private var dataSource: PeopleDataSourceMock!
    private var repository: PeopleRepository!
    private var faker = Faker()
    
    override func setUp() {
        super.setUp()
        dataSource = mock(PeopleDataSource.self)
        repository = DefaultPeopleRepository(peopleDataSource: dataSource)
    }
    
    private func generatePeople() -> PeopleDTO {
        PeopleDTO(name: faker.name.name(),
               height: String(faker.number.randomInt(min: 150, max: 210)),
               mass: String(faker.number.randomInt(min: 40, max: 120)),
               hairColor: faker.commerce.color(),
               skinColor: faker.commerce.color(),
               eyeColor: faker.commerce.color(),
               birthYear: "\(faker.number.randomInt(min: 0, max: 1000))BBY",
               gender: faker.gender.type())
    }
    
    func testFindPeopleListSuccess() async {
        // Given
        let testPeopleListDTOs = [generatePeople(), generatePeople()]
        let testPeopleList = testPeopleListDTOs.compactMap { $0.toDomain() }
        given(await dataSource.findPeopleList()).willReturn(testPeopleListDTOs)
        
        // When
        let peopleList = try? await repository.findPeopleList()
        
        // Then
        verify(await dataSource.findPeopleList()).wasCalled(once)
        XCTAssertNotNil(peopleList)
        XCTAssertTrue(peopleList!.elementsEqual(testPeopleList))
    }
    
    func testFindPeopleListFailure() async {
        // Given
        givenSwift(await dataSource.findPeopleList()).will { throw PeopleError.unknown }
        
        // When
        var sutError: Error?
        do {
            _ = try await repository.findPeopleList()
        } catch {
            sutError = error
        }
        
        // Then
        verify(await dataSource.findPeopleList()).wasCalled(once)
        XCTAssertNotNil(sutError)
        XCTAssertEqual(sutError as? PeopleError, .unknown)
    }

}
