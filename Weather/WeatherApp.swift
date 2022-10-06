//
//  WeatherApp.swift
//  Weather
//
//  Created by Keegan on 14/08/2022.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            if isRunningTests {
                Text("Hello, tests!")
            } else {
                WeatherView()
                    .environmentObject(Context())
            }
        }
    }

    var isRunningTests: Bool {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            print("Running tests. Won't load UI.")
            return true
        } else {
            return false
        }
        #else
        return false
        #endif
    }
}
