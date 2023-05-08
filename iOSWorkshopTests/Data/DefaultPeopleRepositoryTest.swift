//
//  DefaultPeopleRepositoryTest.swift
//  iOSWorkshopTests
//
//  Created by Mattei, Marco-MIGROSONLINE on 27.03.23.
//

@testable import iOSWorkshop
import Combine
import Cuckoo
import Fakery
import XCTest

class DefaultPeopleRepositoryTest: XCTestCase {

    private var dataSource = MockPeopleDataSource()
    private var repository: PeopleRepository!
    private var faker = Faker()

    override func setUp() {
        super.setUp()
        reset(dataSource)
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
        stub(dataSource) { stub in
            when(stub.findPeopleList()).thenReturn(testPeopleListDTOs)
        }

        // When
        let peopleList = try? await repository.findPeopleList()

        // Then
        verify(dataSource).findPeopleList()
        XCTAssertNotNil(peopleList)
        XCTAssertTrue(peopleList!.elementsEqual(testPeopleList))
    }

    func testFindPeopleListFailure() async {
        // Given
        stub(dataSource) { stub in
            when(stub.findPeopleList()).thenThrow(PeopleError.unknown)
        }

        // When
        var sutError: Error?
        do {
            _ = try await repository.findPeopleList()
        } catch {
            sutError = error
        }

        // Then
        verify(dataSource).findPeopleList()
        XCTAssertNotNil(sutError)
        XCTAssertEqual(sutError as? PeopleError, .unknown)
    }

}
