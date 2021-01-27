//
//  NetworkManager.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "Not authorised"
    case badRequest = "Sorry, we are making a few updates in our server. Please, come back in a few minutes."
    case outdated = "The url you requested is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode the response"
    case networkError = "Please check your network connection"
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    static let UserAPIKey = ""
    let routerMain = Router<MainApi>()
    
    func getWeather(for city: String, completion: @escaping (_ cityWeather: CityWeather?,_ error: String?)->()){
        routerMain.request(.weather(city: city)) { data, response, error in
            
            if error != nil {
                completion(nil, NetworkResponse.networkError.rawValue)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, nil)
                        return
                    }
                    do {
                        print(responseData)
                        let apiResponse = try JSONDecoder().decode(CityWeather.self, from: responseData)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure:
                    completion(nil, mapError(data: data))
                }
            }
        }
    }
    
    func getGroupWeather(for idList: [String], completion: @escaping (_ cityWeather: [CityWeather]?,_ error: String?)->()){
        routerMain.request(.groupWeather(cityIds: idList)) { data, response, error in
            
            if error != nil {
                completion(nil, NetworkResponse.networkError.rawValue)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, nil)
                        return
                    }
                    do {
                        print(responseData)
                        let apiResponse = try JSONDecoder().decode(CityWeatherResponse.self, from: responseData)
                        completion(apiResponse.list, nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure:
                    completion(nil, mapError(data: data))
                }
            }
        }
    }
    
    
    func mapError(data: Data?) -> String? {
        guard let responseData = data else {
            return nil
        }
        do {
            print(responseData)
            let apiResponse = try JSONDecoder().decode(ResponseError.self, from: responseData)
            return apiResponse.message
        }catch {
            return NetworkResponse.unableToDecode.rawValue
        }
    }
    
    func cancelRequest() {
        routerMain.cancel()
    }
    
    public func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...403: return .failure(NetworkResponse.authenticationError.rawValue )
        case 404...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
