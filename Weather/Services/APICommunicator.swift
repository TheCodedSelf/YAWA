//
//  APIClient.swift
//  Weather
//
//  Created by Keegan on 15/08/2022.
//

import Foundation
import Combine

enum APIError: Error {
    case badResponse
}

protocol APICommunicating {
    func fetchCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherReport, Error>
}

struct APICommunicator: APICommunicating {
    private let session = URLSession.shared
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    private let apiKey: String

    init() {
        if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            self.apiKey = apiKey
        } else {
            apiKey = "invalid"
            assertionFailure("No API Key! Please check the README")
        }
    }

    func fetchCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherReport, Error> {
        let url = makeURL(endpoint: "weather",
                          parameters: [
                            "lat" : "\(latitude)",
                            "lon" : "\(longitude)",
                            "units" : "metric"
                          ])
        return session.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard
                    let response = result.response as? HTTPURLResponse,
                    response.statusCode > 199 && response.statusCode < 300 else {
                    throw APIError.badResponse
                }
                return result.data
            }
            .decode(type: WeatherReport.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func makeURL(endpoint: String, parameters: [String: String] = [:]) -> URL {
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            preconditionFailure("Bad URL! \(baseURL + endpoint)")
        }
        var parametersWithKey = parameters
        parametersWithKey["appid"] = apiKey
        urlComponents.queryItems = parametersWithKey.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = urlComponents.url else {
            preconditionFailure("Couldn't create URL!")
        }
        return url
    }
}
