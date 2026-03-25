import Foundation

struct LeaderboardEntry: Identifiable, Codable, Hashable, Sendable {
    var userId: UUID
    var displayName: String
    var xp: Int
    var level: Int
    var rank: Int

    var id: UUID { userId }
}

// MARK: - Mock Data

extension LeaderboardEntry {
    static let mockList: [LeaderboardEntry] = [
        LeaderboardEntry(userId: UUID(), displayName: "Sarah M.", xp: 8450, level: 24, rank: 1),
        LeaderboardEntry(userId: UUID(), displayName: "James K.", xp: 7200, level: 21, rank: 2),
        LeaderboardEntry(userId: UUID(), displayName: "Maria G.", xp: 6100, level: 19, rank: 3),
        LeaderboardEntry(userId: UUID(), displayName: "Blake", xp: 2450, level: 12, rank: 4),
        LeaderboardEntry(userId: UUID(), displayName: "David L.", xp: 2100, level: 11, rank: 5),
        LeaderboardEntry(userId: UUID(), displayName: "Emma W.", xp: 1800, level: 10, rank: 6),
        LeaderboardEntry(userId: UUID(), displayName: "Chris P.", xp: 1500, level: 9, rank: 7),
        LeaderboardEntry(userId: UUID(), displayName: "Anna R.", xp: 1200, level: 8, rank: 8),
        LeaderboardEntry(userId: UUID(), displayName: "Tom H.", xp: 900, level: 6, rank: 9),
        LeaderboardEntry(userId: UUID(), displayName: "Lisa N.", xp: 600, level: 4, rank: 10),
    ]
}
