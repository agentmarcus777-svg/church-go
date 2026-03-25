import Foundation

struct AppUser: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var displayName: String
    var email: String
    var xp: Int
    var level: Int
    var streak: Int
    var badges: [UUID]
    var totalChurches: Int

    var xpForCurrentLevel: Int {
        GamificationConfig.xpRequired(for: level)
    }

    var xpForNextLevel: Int {
        GamificationConfig.xpRequired(for: level + 1)
    }

    var levelProgress: Double {
        let currentLevelXP = xpForCurrentLevel
        let nextLevelXP = xpForNextLevel
        let range = nextLevelXP - currentLevelXP
        guard range > 0 else { return 1.0 }
        return Double(xp - currentLevelXP) / Double(range)
    }
}

// MARK: - Gamification Config

enum GamificationConfig {
    static func xpRequired(for level: Int) -> Int {
        // Exponential curve: each level needs more XP
        Int(100 * pow(1.15, Double(level - 1)))
    }
}

// MARK: - Mock Data

extension AppUser {
    static let mock = AppUser(
        id: UUID(),
        displayName: "Blake",
        email: "blake@churchgo.app",
        xp: 2450,
        level: 12,
        streak: 7,
        badges: [],
        totalChurches: 34
    )
}
