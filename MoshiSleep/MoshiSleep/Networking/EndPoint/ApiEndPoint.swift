//
//  ApiEndPoint.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum MainApi {
    case weather(city: String)
    case groupWeather(cityIds: [String])
}

extension MainApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
            case .production: return C.http + C.baseURL.production
            case .qa: return C.http + C.baseURL.qa
            case .staging: return C.http + C.baseURL.staging
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
            case .weather:
                return "/weather"
            case .groupWeather:
                return "/group"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .weather:
                return .get
            case .groupWeather:
                return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
            case .weather(let city):
                return .requestParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: [ "q": city,
                                                           "units": "metric",
                                                           "appid": C.Constants.apiKey])
            case .groupWeather(let ids):
                return .requestParameters(bodyParameters: nil,
                                          bodyEncoding: .urlEncoding,
                                          urlParameters: [ "id": ids.joined(separator: ","),
                                                           "units": "metric",
                                                           "appid": C.Constants.apiKey])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
