//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Keegan on 14/08/2022.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: ObservableObject {
    struct DataPointModel {
        let title: String
        let value: String
    }
    struct DataModel {
        let location: String
        let temperature: String
        let feelsLike: String
        let dataPoints: [DataPointModel]
    }
    enum State {
        case loading
        case loaded(DataModel)
        case error(String)
    }
    @Published var state = State.loading {
        didSet {
            if case .loaded(let dataModel) = state {
                lastLocationModel = dataModel
            }
        }
    }

    private let locator: Locating
    private let apiClient: APICommunicating
    private var lastLocationModel: DataModel?
    private var weatherCancellable: AnyCancellable?

    init(locator: Locating, apiClient: APICommunicating) {
        self.locator = locator
        self.apiClient = apiClient
    }

    func locate() {
        state = .loading
        locator.fetchLocation(onComplete: handleFetchedLocation)
    }

    func search(text: String) {
        state = .loading
        locator.searchLocation(text, onComplete: handleFetchedLocation)
    }

    func reload() {
        if let lastLocationModel = lastLocationModel {
            state = .loaded(lastLocationModel)
        } else {
            locate()
        }
    }

    private func handleFetchedLocation(result: Result<Location, Error>) {
        switch result {
        case .success(let currentLocation):
            fetchWeatherData(coordinate: currentLocation.coordinate)
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }

    private func fetchWeatherData(coordinate: CLLocationCoordinate2D) {
        weatherCancellable = apiClient.fetchCurrentWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            .sink(receiveCompletion: { [weak self] in
                if case .failure(let error) = $0 {
                    self?.state = .error(error.localizedDescription)
                }
            }, receiveValue: populate(with:))
    }

    private func populate(with weather: WeatherReport) {
        var dataPoints: [DataPointModel] = [
        .init(title: "Min", value: "\(toString(weather.stats.minTemperature)) °C"),
        .init(title: "Max", value: "\(toString(weather.stats.maxTemperature)) °C"),
        .init(title: "Pressure", value: "\(weather.stats.pressure) hPa"),
        .init(title: "Humidity", value: "\(weather.stats.humidity) %"),
        .init(title: "Visibility", value: "\(weather.visibility / 1000) km"),
        .init(title: "Cloud cover", value: "\(weather.clouds.percent) %")
        ]

        weather.rain.flatMap { dataPoints.append(.init(title: "Rain (1 hour)", value: "\($0.oneHourFall) mm")) }
        weather.snow.flatMap { dataPoints.append(.init(title: "Snow (1 hour)", value: "\($0.oneHourFall) mm")) }

        let sunrise = Date(timeIntervalSince1970: weather.additional.sunriseTimestampUTC)
        let sunset = Date(timeIntervalSince1970: weather.additional.sunsetTimestampUTC)
        let timezone = TimeZone(secondsFromGMT: weather.timeShift)
        let sunFormatter = DateFormatter()
        sunFormatter.dateFormat = "HH:mm"
        sunFormatter.timeZone = timezone
        dataPoints.append(contentsOf: [
            .init(title: "Sunrise", value: sunFormatter.string(from: sunrise)),
            .init(title: "Sunset", value: sunFormatter.string(from: sunset)),
        ])

        let dataModel = DataModel(
            location: weather.name,
            temperature: "\(toString(weather.stats.temperature)) °C",
            feelsLike: "\(toString(weather.stats.feelsLike)) °C", dataPoints: dataPoints)
        state = .loaded(dataModel)
    }

    private func toString(_ value: Double) -> String {
        String(format: "%.0f", value)
    }
}
