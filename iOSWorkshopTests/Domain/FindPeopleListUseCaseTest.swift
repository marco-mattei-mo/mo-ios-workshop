//
//  PeopleListViewModelTest.swift
//  iOSWorkshopTests
//
//  Created by Mattei, Marco-MIGROSONLINE on 27.03.23.
//

@testable import iOSWorkshop
import Combine
import Cuckoo
import Fakery
import XCTest

class FindPeopleListUseCaseTest: XCTestCase {

    private var repository = MockPeopleRepository()
    private var useCase: FindPeopleListUseCase!
    private var faker = Faker()

    override func setUp() {
        super.setUp()
        reset(repository)
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
        stub(repository) { stub in
            when(stub.findPeopleList()).thenReturn(testPeopleList)
        }

        // When
        let peopleList = try? await useCase.execute()

        // Then
        verify(repository).findPeopleList()
        XCTAssertNotNil(peopleList)
        XCTAssertTrue(peopleList!.elementsEqual(testPeopleList))
    }

    func testFindPeopleListUseCaseFailure() async {
        // Given
        stub(repository) { stub in
            when(stub.findPeopleList()).thenThrow(PeopleError.unknown)
        }

        // When
        var sutError: Error?
        do {
            _ = try await useCase.execute()
        } catch {
            sutError = error
        }

        // Then
        verify(repository).findPeopleList()
        XCTAssertNotNil(sutError)
        XCTAssertEqual(sutError as? PeopleError, .unknown)
    }
}
