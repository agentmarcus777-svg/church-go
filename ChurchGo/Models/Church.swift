import Foundation
import CoreLocation

struct Church: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var name: String
    var denomination: String
    var latitude: Double
    var longitude: Double
    var address: String
    var photoURL: String?
    var isHistoric: Bool
    var visitCount: Int
    var city: String? = nil
    var state: String? = nil
    var country: String? = nil
    var wikipediaURL: String? = nil

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var photoURLValue: URL? {
        guard let photoURL else { return nil }
        return URL(string: photoURL)
    }

    var locationSummary: String {
        let parts = [city, state, country]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        if parts.isEmpty {
            return address
        }

        return parts.joined(separator: ", ")
    }
}

// MARK: - Mock Data

extension Church {
    static let mock = Church(
        id: UUID(),
        name: "St. Patrick's Cathedral",
        denomination: "Catholic",
        latitude: 40.7584,
        longitude: -73.9759,
        address: "5th Ave, New York, NY 10022",
        photoURL: nil,
        isHistoric: true,
        visitCount: 1247,
        city: "New York",
        state: "NY",
        country: "USA",
        wikipediaURL: "https://en.wikipedia.org/wiki/St._Patrick%27s_Cathedral_(Midtown_Manhattan)"
    )

    static let mockList: [Church] = [
        .mock,
        Church(
            id: UUID(),
            name: "Trinity Church",
            denomination: "Episcopal",
            latitude: 40.7081,
            longitude: -74.0124,
            address: "75 Broadway, New York, NY 10006",
            photoURL: nil,
            isHistoric: true,
            visitCount: 892,
            city: "New York",
            state: "NY",
            country: "USA",
            wikipediaURL: "https://en.wikipedia.org/wiki/Trinity_Church_(Manhattan)"
        ),
        Church(
            id: UUID(),
            name: "Riverside Church",
            denomination: "Interdenominational",
            latitude: 40.8115,
            longitude: -73.9632,
            address: "490 Riverside Dr, New York, NY 10027",
            photoURL: nil,
            isHistoric: false,
            visitCount: 456,
            city: "New York",
            state: "NY",
            country: "USA",
            wikipediaURL: "https://en.wikipedia.org/wiki/Riverside_Church"
        ),
        Church(
            id: UUID(),
            name: "Grace Cathedral",
            denomination: "Episcopal",
            latitude: 37.7915,
            longitude: -122.4130,
            address: "1100 California St, San Francisco, CA 94108",
            photoURL: nil,
            isHistoric: true,
            visitCount: 2103,
            city: "San Francisco",
            state: "CA",
            country: "USA",
            wikipediaURL: "https://en.wikipedia.org/wiki/Grace_Cathedral,_San_Francisco"
        ),
        Church(
            id: UUID(),
            name: "First Baptist Church",
            denomination: "Baptist",
            latitude: 34.0522,
            longitude: -118.2437,
            address: "760 S Westmoreland Ave, Los Angeles, CA 90005",
            photoURL: nil,
            isHistoric: false,
            visitCount: 334,
            city: "Los Angeles",
            state: "CA",
            country: "USA",
            wikipediaURL: "https://en.wikipedia.org/wiki/First_Baptist_Church_(disambiguation)"
        ),
    ]
}
