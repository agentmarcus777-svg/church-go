import Foundation
import MapKit
import Combine

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

    init(locationService: LocationService = LocationService(), churchService: ChurchService = ChurchService()) {
        self.locationService = locationService
        self.churchService = churchService
    }

    func loadChurches() async {
        isLoading = true
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
        guard let location = locationService.currentLocation else { return Array(churches.prefix(limit)) }
        return churches
            .sorted { a, b in
                let distA = location.distance(from: CLLocation(latitude: a.latitude, longitude: b.longitude))
                let distB = location.distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
                return distA < distB
            }
            .prefix(limit)
            .map { $0 }
    }

    /// For previews
    static var preview: MapViewModel {
        let vm = MapViewModel()
        vm.churches = Church.mockList
        vm.visitedChurchIDs = [Church.mockList[0].id, Church.mockList[1].id]
        return vm
    }
}
