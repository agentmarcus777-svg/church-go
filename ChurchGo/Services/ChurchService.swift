import Foundation
import CoreLocation

@MainActor
final class ChurchService: ObservableObject {
    @Published var churches: [Church] = []
    @Published var isLoading: Bool = false

    private let supabase = SupabaseService.shared

    func fetchNearbyChurches(location: CLLocationCoordinate2D, radiusKm: Double = 50) async {
        isLoading = true
        defer { isLoading = false }

        churches = Church.mockList
    }

    func searchChurches(query: String) async -> [Church] {
        guard !query.isEmpty else { return churches }

        return churches.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.denomination.localizedCaseInsensitiveContains(query)
        }
    }

    func getChurch(id: UUID) async -> Church? {
        churches.first { $0.id == id }
    }

    /// Load mock data for previews / development
    func loadMockData() {
        churches = Church.mockList
    }
}
