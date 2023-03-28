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

class PeopleConvertersTest: XCTestCase {
    
    private var peopleData: Data!
    
    override func setUp() {
        super.setUp()
        guard let url = Bundle(for: type(of: self)).url(forResource: "people", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            XCTFail()
            return
        }
        peopleData = data
    }
    
    func testPeopleObjectConversions() {
        var jsonToDTO: [PeopleDTO]?
        var dtoToDomain: [People]?
        let expectation = self.expectation(description: "Should decode mock response")

        do {
            jsonToDTO = try JSONDecoder().decode(PeopleListResultDTO.self, from: peopleData).results
            dtoToDomain = jsonToDTO?.compactMap{ $0.toDomain() }
            expectation.fulfill()
        } catch {
            XCTFail("Failed decoding MockObject")
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(jsonToDTO)
        XCTAssertNotNil(dtoToDomain)
        
        XCTAssertEqual(jsonToDTO?.count, 10)
        XCTAssertEqual(dtoToDomain?.count, 10)
        
        let firstDTOPeople = jsonToDTO?.first
        let firstDomainPeople = dtoToDomain?.first

        XCTAssertEqual(firstDTOPeople?.name, "Luke Skywalker")
        XCTAssertEqual(firstDTOPeople?.height, "172")
        XCTAssertEqual(firstDTOPeople?.mass, "77")
        XCTAssertEqual(firstDTOPeople?.hairColor, "blond")
        XCTAssertEqual(firstDTOPeople?.skinColor, "fair")
        XCTAssertEqual(firstDTOPeople?.eyeColor, "blue")
        XCTAssertEqual(firstDTOPeople?.birthYear, "19BBY")
        XCTAssertEqual(firstDTOPeople?.gender, "male")

        
        XCTAssertEqual(firstDomainPeople?.name, "Luke Skywalker")
        XCTAssertEqual(firstDomainPeople?.height, 172)
        XCTAssertEqual(firstDomainPeople?.mass, 77)
        XCTAssertEqual(firstDomainPeople?.hairColor, "blond")
        XCTAssertEqual(firstDomainPeople?.skinColor, "fair")
        XCTAssertEqual(firstDomainPeople?.eyeColor, "blue")
        XCTAssertEqual(firstDomainPeople?.birthYear, "19BBY")
        XCTAssertEqual(firstDomainPeople?.gender, "male")
    }
}
