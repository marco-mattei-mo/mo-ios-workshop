//
//  NetworkPeopleDataSourceTest.swift
//  iOSWorkshopTests
//
//  Created by Mattei, Marco-MIGROSONLINE on 27.03.23.
//
@testable import iOSWorkshop
import Mocker
import XCTest

class NetworkPeopleDataSourceTest: XCTestCase {
    private var dataSource = NetworkPeopleDataSource()
    
    override func tearDown() {
        super.tearDown()
        Mocker.removeAll()
    }
    
    func testFindPeopleListSuccessful() async throws {
        // Given
        guard let filePath = Bundle(for: type(of: self)).url(forResource: "people", withExtension: "json"),
              let data = try? Data(contentsOf: filePath) else {
            XCTFail()
            return
        }
        let url = URL(string:"https://swapi.dev/api/people")!
        let mock = Mock(url: url, dataType: .json, statusCode: 200, data: [.get: data])
        mock.register()
        
        // When
        let result = try await dataSource.findPeopleList()
        
        // Then
        XCTAssertEqual(result.count, 10)
    }
    
    func testFindPeopleListNoInternet() async throws {
        // Given
        let url = URL(string:"https://swapi.dev/api/people")!
        let mock = Mock(url: url, dataType: .json, statusCode: 500, data: [.get: Data()], requestError: URLError(.notConnectedToInternet))
        mock.register()
        
        var sutError: Error?
        
        // When
        do {
            _ = try await dataSource.findPeopleList()
        } catch {
            sutError = error
        }
        
        // Then
        XCTAssertNotNil(sutError)
        XCTAssertEqual(sutError as? PeopleError, .noInternet)
    }
    
    func testFindPeopleListError() async throws {
        // Given
        let url = URL(string:"https://swapi.dev/api/people")!
        let mock = Mock(url: url, dataType: .json, statusCode: 500, data: [.get: Data()])
        mock.register()
        
        var sutError: Error?
        
        // When
        do {
            _ = try await dataSource.findPeopleList()
        } catch {
            sutError = error
        }
        
        // Then
        XCTAssertNotNil(sutError)
        XCTAssertEqual(sutError as? PeopleError, .unknown)
    }
}
