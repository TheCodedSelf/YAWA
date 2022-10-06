//
//  StubAPIClient.swift
//  WeatherTests
//
//  Created by Keegan on 16/10/2022.
//

import Foundation
import Combine
@testable import Weather

class StubAPIClient: APICommunicating {
    var stubbedCurrentWeather: WeatherReport?
    func fetchCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherReport, Error> {
        if let stubbedCurrentWeather {
            let subject = CurrentValueSubject<WeatherReport, Error>(stubbedCurrentWeather)
            return subject.eraseToAnyPublisher()
        } else {
            let subject = PassthroughSubject<WeatherReport, Error>()
            subject.send(completion: .failure(TestError.noStub))
            return subject.eraseToAnyPublisher()
        }
    }
}
