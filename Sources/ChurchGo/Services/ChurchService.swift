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

        do {
            let response: [Church] = try await supabase.client
                .from("churches")
                .select()
                .execute()
                .value
            churches = response
        } catch {
            // Fall back to mock data for development
            print("Fetch error: \(error.localizedDescription)")
            churches = Church.mockList
        }
    }

    func searchChurches(query: String) async -> [Church] {
        guard !query.isEmpty else { return churches }

        do {
            let response: [Church] = try await supabase.client
                .from("churches")
                .select()
                .ilike("name", pattern: "%\(query)%")
                .execute()
                .value
            return response
        } catch {
            // Fall back to local filter for development
            return churches.filter {
                $0.name.localizedCaseInsensitiveContains(query) ||
                $0.denomination.localizedCaseInsensitiveContains(query)
            }
        }
    }

    func getChurch(id: UUID) async -> Church? {
        do {
            let response: Church = try await supabase.client
                .from("churches")
                .select()
                .eq("id", value: id.uuidString)
                .single()
                .execute()
                .value
            return response
        } catch {
            return churches.first { $0.id == id }
        }
    }

    /// Load mock data for previews / development
    func loadMockData() {
        churches = Church.mockList
    }
}
