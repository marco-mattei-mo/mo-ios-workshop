import Foundation

class NetworkPeopleDataSource: PeopleDataSource {
    
    func findPeopleList() async throws -> [PeopleDTO] {
        let url = URL(string: "https://swapi.dev/api/people")!
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let peopleListResult = try JSONDecoder().decode(PeopleListResultDTO.self, from: data)
            return peopleListResult.results
        } catch let error as URLError where error.code == URLError.Code.notConnectedToInternet {
            throw PeopleError.noInternet
        } catch {
            throw PeopleError.unknown
        }

    }
        
}
