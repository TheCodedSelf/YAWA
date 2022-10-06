//
//  StubLocator.swift
//  WeatherTests
//
//  Created by Keegan on 16/10/2022.
//

import Foundation
@testable import Weather

class StubLocator: Locating {
    var stubFetchLocation: Location?
    var stubSearchLocations = [String: Location]()

    func fetchLocation(onComplete: @escaping LocationRequest) {
        if let stubFetchLocation {
            onComplete(.success(stubFetchLocation))
        } else {
            onComplete(.failure(TestError.noStub))
        }
    }

    func searchLocation(_ searchText: String, onComplete: @escaping LocationRequest) {
        if let stubLocation = stubSearchLocations[searchText] {
            onComplete(.success(stubLocation))
        } else {
            onComplete(.failure(TestError.noStub))
        }
    }

}
