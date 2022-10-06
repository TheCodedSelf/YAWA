//
//  Context.swift
//  Weather
//
//  Created by Keegan on 24/08/2022.
//

import Foundation

class Context: ObservableObject {
    @Published var currentLocation: Location?
}
