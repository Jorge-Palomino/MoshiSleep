//
//  CityWeather.swift
//  MoshiSleep
//
//  Created by Jorge Palomino on 26/01/2021.
//

import Foundation
import UIKit

struct CityWeatherResponse: Codable {
    let count: Int
    let list: [CityWeather]
    
    enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case list
    }
}

struct CityWeather: Codable {
    let coordinates: Coordinates
    let weather: [Weather]
    let base: String?
    let main: WeatherMain
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int64
    let sys: SysData
    let timezone: Int?
    let id: Int64
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dt
        case sys
        case timezone
        case id
        case name
    }
}

enum WeatherType: String, Codable {
    case Thunderstorm 
    case Drizzle
    case Rain
    case Snow
    case Atmosphere
    case Clear
    case Clouds
    
    func getLightColor() -> UIColor {
        switch self {
        case .Thunderstorm:
            return .lightThunder
        case .Drizzle:
            return .lightRain
        case .Rain:
            return .lightRain
        case .Snow:
            return .lightSnow
        case .Atmosphere:
            return .lightSnow
        case .Clear:
            return .lightSunny
        default:
            return .lightCloud
        }
    }
    
    func getDarkColor() -> UIColor {
        switch self {
        case .Thunderstorm:
            return .darkThunder
        case .Drizzle:
            return .darkRain
        case .Rain:
            return .darkRain
        case .Snow:
            return .darkSnow
        case .Atmosphere:
            return .darkSnow
        case .Clear:
            return .darkSunny
        default:
            return .darkCloud
        }
    }
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
    
    enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }
}

struct Weather: Codable {
    let id: Int
    let main: WeatherType
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}

struct WeatherMain: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }
}

struct Clouds: Codable {
    let all: Int
    
    enum CodingKeys: String, CodingKey {
        case all
    }
}

struct SysData: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int64
    let sunset: Int64
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case country
        case sunrise
        case sunset
    }
}
