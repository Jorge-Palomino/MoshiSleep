//
//  ResponseError.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation

struct ResponseError: Decodable {
    let cod: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case cod
        case message
    }
}
