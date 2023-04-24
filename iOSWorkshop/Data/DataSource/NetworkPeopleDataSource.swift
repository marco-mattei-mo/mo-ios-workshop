import Foundation

class NetworkPeopleDataSource: PeopleDataSource {
    
    func findPeopleList() async throws -> [PeopleDTO] {
        let url = URL(string: "https://swapi.dev/api/people")!
        let urlRequest = URLRequest(url: url)
        
        //TODO: Part 8
        /*
         Use URLSession to perform a data request. Then use JSONDecoder() to decode the data into a "PeopleListResultDTO".
         Throw the correct domain error according the the actual error
         */
        do {
            let (data, _) = //TODO: Perform data request
            let peopleListResult = //TODO: Decode the data
            return peopleListResult.results
        } catch let error as URLError where error.code == URLError.Code.notConnectedToInternet {
            //TODO: Throw an error
        } catch {
            //TODO: Throw an error
        }

    }
        
}
