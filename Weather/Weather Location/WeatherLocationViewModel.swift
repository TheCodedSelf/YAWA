//
//  WeatherLocationViewModel.swift
//  Weather
//
//  Created by Keegan on 23/08/2022.
//

import Foundation

class WeatherLocationViewModel: ObservableObject {
    enum State {
        case loading
        case loaded(String)
        case searching
    }

    @Published var state = State.loading {
        didSet {
            if case .loaded(let location) = state {
                loadedLocation = location
            }
        }
    }
    private var loadedLocation: String?

    func searchTapped() {
        state = .searching
    }

    func locateTapped() {
        state = .loading
    }

    func restoreState() {
        if let previouslyLoadedLocation = loadedLocation {
            state = .loaded(previouslyLoadedLocation)
        }
    }
}
