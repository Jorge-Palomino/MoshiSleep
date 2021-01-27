//
//  URLEncoding.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                if type(of: value) == [String].self {
                    for val in value as! [String] {
                        let queryItem = URLQueryItem(name: key,
                                                     value: String(describing: val))
                        urlComponents.queryItems?.append(queryItem)
                    }
                }else {
                    let queryItem = URLQueryItem(name: key,
                                                 value: String(describing: value))
                    urlComponents.queryItems?.append(queryItem)
                }
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
    }
}
