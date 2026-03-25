import Foundation
import MapKit
import Combine
import SwiftUI

@MainActor
final class MapViewModel: ObservableObject {
    @Published var churches: [Church] = []
    @Published var selectedChurch: Church?
    @Published var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var visitedChurchIDs: Set<UUID> = []
    @Published var showNearbySheet: Bool = true

    let locationService: LocationService
    private let churchService: ChurchService

    init(locationService: LocationService? = nil, churchService: ChurchService? = nil) {
        self.locationService = locationService ?? .shared
        self.churchService = churchService ?? ChurchService()
    }

    var filteredChurches: [Church] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return churches
        }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return churches.filter { church in
            church.name.localizedCaseInsensitiveContains(query)
                || church.denomination.localizedCaseInsensitiveContains(query)
                || church.locationSummary.localizedCaseInsensitiveContains(query)
        }
    }

    func loadChurches() async {
        isLoading = true
        locationService.startUpdating()

        if let location = locationService.currentLocation?.coordinate {
            await churchService.fetchNearbyChurches(location: location)
        } else {
            churchService.loadMockData()
        }
        churches = churchService.churches
        isLoading = false
    }

    func selectChurch(_ church: Church) {
        selectedChurch = church
        withAnimation(Theme.springAnimation) {
            cameraPosition = .region(MKCoordinateRegion(
                center: church.coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            ))
        }
    }

    func isVisited(_ church: Church) -> Bool {
        visitedChurchIDs.contains(church.id)
    }

    func nearbyChurches(limit: Int = 5) -> [Church] {
        guard let location = locationService.currentLocation else { return Array(filteredChurches.prefix(limit)) }

        return filteredChurches
            .sorted { a, b in
                let distA = location.distance(from: CLLocation(latitude: a.latitude, longitude: a.longitude))
                let distB = location.distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
                return distA < distB
            }
            .prefix(limit)
            .map { $0 }
    }

    /// For previews
    static var preview: MapViewModel {
        let vm = MapViewModel(locationService: LocationService())
        vm.churches = Church.mockList
        vm.visitedChurchIDs = [Church.mockList[0].id, Church.mockList[1].id]
        return vm
    }
}
