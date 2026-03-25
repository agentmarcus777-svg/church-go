import Foundation

struct CheckIn: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var userId: UUID
    var churchId: UUID
    var timestamp: Date
    var xpEarned: Int
}

// MARK: - Mock Data

extension CheckIn {
    static let mock = CheckIn(
        id: UUID(),
        userId: AppUser.mock.id,
        churchId: Church.mock.id,
        timestamp: Date(),
        xpEarned: 150
    )
}
