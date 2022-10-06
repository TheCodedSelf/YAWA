//
//  Locator.swift
//  Weather
//
//  Created by Keegan on 14/08/2022.
//

import Foundation
import CoreLocation

typealias LocationRequest = (Result<Location, Error>) -> ()

struct Location {
    let city: String
    let coordinate: CLLocationCoordinate2D
}

enum LocationError: LocalizedError {
    case notAuthorized
    case failed
}

protocol Locating {
    func fetchLocation(onComplete: @escaping LocationRequest)
    func searchLocation(_ searchText: String, onComplete: @escaping LocationRequest)
}

class Locator: NSObject, Locating {
    private let locationManager = CLLocationManager()
    private var authorizationStatus: CLAuthorizationStatus
    private var locationRequest: LocationRequest?

    override init() {
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
    }

    func fetchLocation(onComplete: @escaping LocationRequest) {
        locationRequest = onComplete
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            fallthrough
        case .denied:
            completeRequest(result: .failure(LocationError.notAuthorized))
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            fallthrough
        case .authorized:
            fallthrough
        @unknown default:
            locationManager.requestLocation()

        }
    }

    func searchLocation(_ searchText: String, onComplete: @escaping LocationRequest) {
        print("Searching for \(searchText)")
        locationRequest = onComplete
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText, completionHandler: { [weak self] placemarks, error in
            guard
                let placemark = placemarks?.first,
                let city = placemark.locality,
                let coordinate = placemark.location?.coordinate else {
                self?.completeRequest(result: .failure(error ?? LocationError.failed))
                return
            }
            let location = Location(city: city, coordinate: coordinate)
            self?.completeRequest(result: .success(location))
        })
    }

    private func handleLocation(_ coreLocation: CLLocation) {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(coreLocation) { [weak self] placemarks, error in
                if let placemark = placemarks?.first {
                    let location = Location(city: placemark.locality ?? "Unknown",
                                            coordinate: coreLocation.coordinate)
                    self?.completeRequest(result: .success(location))
                } else {
                    self?.completeRequest(result: .failure(error ?? LocationError.failed))
                }
            }
    }

    private func completeRequest(result: Result<Location, Error>) {
        locationRequest?(result)
        locationRequest = nil
    }
}

extension Locator: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completeRequest(result: .failure(error))
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        completeRequest(result: .failure(error))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        guard locationRequest != nil else { return }
        switch authorizationStatus {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            fallthrough
        case .authorized:
            locationManager.requestLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            handleLocation(location)
        } else {
            completeRequest(result: .failure(LocationError.failed))
        }
    }
}
