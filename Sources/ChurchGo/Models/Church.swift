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

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
        visitCount: 1247
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
            visitCount: 892
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
            visitCount: 456
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
            visitCount: 2103
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
            visitCount: 334
        ),
    ]
}
