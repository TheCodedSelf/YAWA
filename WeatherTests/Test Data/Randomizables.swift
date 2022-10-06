//
//  Randomizables.swift
//  WeatherTests
//
//  Created by Keegan on 23/10/2022.
//

import Foundation
import CoreLocation
@testable import Weather

extension String {
    static func random(_ prefix: String = "Random") -> String {
        "\(prefix) \(Int.random(in: 0...9999))"
    }
}

extension CLLocationCoordinate2D {
    static func random() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: .random(), longitude: .random())
    }
}

extension Double {
    static func random(min: Double = 0, max: Double = 10000) -> Double {
        .random(in: min...max)
    }
}

extension WeatherReport {
    static func random() -> WeatherReport {
        WeatherReport(patterns: [.random(), .random()],
                      stats: .random(),
                      visibility: .random(in: 0...100),
                      clouds: .random(),
                      rain: Optional.random(.random()),
                      snow: Optional.random(.random()),
                      additional: .random(),
                      name: .random("Weather Report"),
                      timeShift: .random(in: 0...2))
    }
}

extension WeatherPattern {
    static func random()  -> WeatherPattern {
        WeatherPattern(main: .random("Pattern title"), description: .random("Pattern description"))
    }
}

extension WeatherStats {
    static func random() -> WeatherStats {
        let temperature = Double.random(in: 0...200)
        let feelsLike = temperature + .random(in: -5...5)
        let min = temperature - Double.random(in: 0...20)
        let max = temperature + Double.random(in: 0...20)
        return WeatherStats(temperature: temperature,
                            feelsLike: feelsLike,
                            minTemperature: min,
                            maxTemperature: max,
                            pressure: .random(in: 950...1050),
                            humidity: .random(in: 0...100))
    }
}

extension CloudCover {
    static func random() -> CloudCover {
        CloudCover(percent: .random(in: 0...100))
    }
}

extension Optional  {
    static func random(_ wrapped: Wrapped) -> Optional<Wrapped> {
        Bool.random() ? .some(wrapped) : .none
    }
}

extension Rain {
    static func random() -> Rain {
        let oneHourFall = Int.random(in: 1...100)
        let threeHourFall = Int.random(in: oneHourFall...oneHourFall * 5)
        return Rain(oneHourFall: oneHourFall, threeHourFall: threeHourFall)
    }
}

extension Snow {
    static func random() -> Snow {
        let rain = Rain.random()
        return Snow(oneHourFall: rain.oneHourFall,
                    threeHourFall: rain.threeHourFall)
    }
}

extension Additional {
    static func random() -> Additional {
        Additional(sunriseTimestampUTC: .random(in: 3...11),
                   sunsetTimestampUTC: .random(in: 13...23),
                   countryCode: .random("Country Code"))
    }
}
