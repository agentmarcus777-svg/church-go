import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationService: NSObject, ObservableObject {
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isAuthorized: Bool = false

    private let locationManager = CLLocationManager()

    /// Check-in proximity radius in meters
    static let checkInRadius: CLLocationDistance = 100

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdating() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }

    func distanceTo(_ coordinate: CLLocationCoordinate2D) -> CLLocationDistance? {
        guard let current = currentLocation else { return nil }
        let target = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return current.distance(from: target)
    }

    func isWithinCheckInRange(of church: Church) -> Bool {
        guard let distance = distanceTo(church.coordinate) else { return false }
        return distance <= Self.checkInRadius
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: @preconcurrency CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        isAuthorized = manager.authorizationStatus == .authorizedWhenInUse
            || manager.authorizationStatus == .authorizedAlways

        if isAuthorized {
            startUpdating()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
