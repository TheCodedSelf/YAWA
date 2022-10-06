//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Keegan on 16/10/2022.
//

import XCTest
@testable import Weather
import Combine

final class WeatherViewModelTests: XCTestCase {
    var serviceUnderTest: WeatherViewModel!
    let stubLocator = StubLocator()
    let stubAPIClient = StubAPIClient()
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
        serviceUnderTest = WeatherViewModel(locator: stubLocator, apiClient: stubAPIClient)
    }

    override func tearDownWithError() throws {
        cancellables.forEach { $0.cancel() }
    }

    func testLocate() {
        let stubLocation = Location(city: .random("City"), coordinate: .random())
        stubLocator.stubFetchLocation = stubLocation
        verifyLocating(serviceUnderTest.locate)
    }

    func testSearch() {
        let searchText = String.random("Search")
        let stubLocation = Location(city: .random("City"), coordinate: .random())
        stubLocator.stubSearchLocations[searchText] = stubLocation
        verifyLocating {
            self.serviceUnderTest.search(text: searchText)
        }
    }

    private func verifyLocating(_ action: () -> (), file: StaticString = #filePath, line: UInt = #line) {
        let expectedWeather = WeatherReport.random()
        stubAPIClient.stubbedCurrentWeather = expectedWeather

        let expectation = self.expectation(description: "Locate")
        serviceUnderTest.$state.sink(receiveValue: { newState in
            if case .loaded = newState {
                expectation.fulfill()
            } else if case .error = newState {
                XCTFail(file: file, line: line)
            }
        })
        .store(in: &cancellables)

        action()
        waitForExpectations(timeout: 1)
    }

}
