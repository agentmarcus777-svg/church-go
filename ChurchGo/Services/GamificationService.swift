import Foundation
import Combine

@MainActor
final class GamificationService: ObservableObject {
    @Published var user: AppUser

    init(user: AppUser = .mock) {
        self.user = user
    }

    // MARK: - XP Calculation

    struct CheckInReward: Sendable {
        var baseXP: Int = 50
        var newChurchBonus: Int = 0
        var historicBonus: Int = 0
        var streakBonus: Int = 0
        var totalXP: Int { baseXP + newChurchBonus + historicBonus + streakBonus }

        var breakdown: [(String, Int)] {
            var items: [(String, Int)] = [("Check-in", baseXP)]
            if newChurchBonus > 0 { items.append(("New Church", newChurchBonus)) }
            if historicBonus > 0 { items.append(("Historic Site", historicBonus)) }
            if streakBonus > 0 { items.append(("Streak Bonus", streakBonus)) }
            return items
        }
    }

    func calculateReward(for church: Church, isNewChurch: Bool) -> CheckInReward {
        var reward = CheckInReward()
        if isNewChurch { reward.newChurchBonus = 100 }
        if church.isHistoric { reward.historicBonus = 50 }
        if user.streak > 0 { reward.streakBonus = 25 }
        return reward
    }

    // MARK: - Apply Check-In

    func applyCheckIn(reward: CheckInReward) -> Bool {
        let previousLevel = user.level
        user.xp += reward.totalXP
        user.totalChurches += 1
        user.streak += 1

        // Check level up
        while user.xp >= user.xpForNextLevel {
            user.level += 1
        }

        return user.level > previousLevel
    }

    // MARK: - Level System

    static func levelTitle(for level: Int) -> String {
        switch level {
        case 1...5: return "Newcomer"
        case 6...10: return "Seeker"
        case 11...20: return "Wanderer"
        case 21...35: return "Pilgrim"
        case 36...50: return "Explorer"
        case 51...70: return "Crusader"
        case 71...90: return "Sage"
        case 91...99: return "Apostle"
        case 100: return "Saint"
        default: return "Newcomer"
        }
    }

    // MARK: - Badge Checks

    func checkBadgeUnlocks() -> [Badge] {
        var newBadges: [Badge] = []
        let allBadges = Badge.mockList

        for badge in allBadges where !badge.isUnlocked {
            let shouldUnlock: Bool = switch badge.name {
            case "First Steps": user.totalChurches >= 1
            case "Explorer": user.totalChurches >= 10
            case "Pilgrim": user.totalChurches >= 50
            case "Crusader": user.totalChurches >= 100
            case "Cathedral": user.totalChurches >= 250
            case "Holy Grail": user.totalChurches >= 1000
            case "Streak Master": user.streak >= 7
            default: false
            }

            if shouldUnlock {
                var unlockedBadge = badge
                unlockedBadge.isUnlocked = true
                newBadges.append(unlockedBadge)
            }
        }

        return newBadges
    }

    // MARK: - Streak

    func checkStreak(lastCheckIn: Date?) -> Bool {
        guard let last = lastCheckIn else { return true }
        let calendar = Calendar.current
        let daysSince = calendar.dateComponents([.day], from: last, to: Date()).day ?? 0
        if daysSince > 1 {
            user.streak = 0
            return false
        }
        return true
    }
}
