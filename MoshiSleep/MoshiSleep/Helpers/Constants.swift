//
//  Constants.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation
import UIKit

struct C {
    
    struct defaultsKeys {
        static let cityWeathers = "cityWeathersInformation"
    }
    
    struct Constants {
        static let apiKey = "" // Add API Key here from https://openweathermap.org/api
        static let imageUrl = "http://openweathermap.org/img/wn/"
        static let x2 = "@2x"
        static let png = ".png"
    }
    
    static let http = "http://"
    static let https = "https://"
    
    struct baseURL {
        static let production: String = "api.openweathermap.org/data/2.5"
        static let qa: String = "api.openweathermap.org/data/2.5"
        static let staging: String = "api.openweathermap.org/data/2.5"
    }
    
    static let cityIds = [
        "2643743", // London
        "1850144", // Tokyo
        "5128581", // New York
        "2950159", // Berlin
        "2988507" // Paris
    ]
    
    static var networkManager: NetworkManager = NetworkManager()
    
    // CONSTRAINTS
    static let horizontalMainConstraint: CGFloat = 15.0
    static let verticalPreviewConstraint: CGFloat = 5.0
    static let horizontalPreviewConstraint: CGFloat = 10.0
}
