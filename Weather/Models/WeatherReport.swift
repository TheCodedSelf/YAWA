//
//  Weather.swift
//  Weather
//
//  Created by Keegan on 15/08/2022.
//

import Foundation

struct WeatherPattern: Codable {
    let main: String
    let description: String
}

struct WeatherStats: Codable {
    let temperature: Double
    let feelsLike: Double
    let minTemperature: Double
    let maxTemperature: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let heading: Int
    enum CodingKeys: String, CodingKey {
        case speed
        case heading = "deg"
    }
}

struct CloudCover: Codable {
    let percent: Int
    enum CodingKeys: String, CodingKey {
        case percent = "all"
    }
}

struct Rain: Codable {
    let oneHourFall: Int
    let threeHourFall: Int
    enum CodingKeys: String, CodingKey {
        case oneHourFall = "rain.1h"
        case threeHourFall = "rain.3h"
    }
}

struct Snow: Codable {
    let oneHourFall: Int
    let threeHourFall: Int
    enum CodingKeys: String, CodingKey {
        case oneHourFall = "snow.1h"
        case threeHourFall = "snow.3h"
    }
}

struct Additional: Codable {
    let sunriseTimestampUTC: TimeInterval
    let sunsetTimestampUTC: TimeInterval
    let countryCode: String
    enum CodingKeys: String, CodingKey {
        case sunriseTimestampUTC = "sunrise"
        case sunsetTimestampUTC = "sunset"
        case countryCode = "country"
    }
}

struct WeatherReport: Codable {
    let patterns: [WeatherPattern]
    let stats: WeatherStats
    let visibility: Int
    let clouds: CloudCover
    let rain: Rain?
    let snow: Snow?
    let additional: Additional
    let name: String
    let timeShift: Int

    enum CodingKeys: String, CodingKey {
        case patterns = "weather"
        case stats = "main"
        case visibility
        case clouds
        case rain
        case snow
        case additional = "sys"
        case name
        case timeShift = "timezone"
    }
}
