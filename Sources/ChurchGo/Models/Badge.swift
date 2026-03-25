import Foundation

struct Badge: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var name: String
    var description: String
    var iconName: String
    var requirement: Int
    var isUnlocked: Bool
}

// MARK: - Mock Data

extension Badge {
    static let mockList: [Badge] = [
        Badge(id: UUID(), name: "First Steps", description: "Visit your first church", iconName: "figure.walk", requirement: 1, isUnlocked: true),
        Badge(id: UUID(), name: "Explorer", description: "Visit 10 churches", iconName: "binoculars.fill", requirement: 10, isUnlocked: true),
        Badge(id: UUID(), name: "Pilgrim", description: "Visit 50 churches", iconName: "figure.hiking", requirement: 50, isUnlocked: false),
        Badge(id: UUID(), name: "Crusader", description: "Visit 100 churches", iconName: "shield.fill", requirement: 100, isUnlocked: false),
        Badge(id: UUID(), name: "Cathedral", description: "Visit 250 churches", iconName: "building.columns.fill", requirement: 250, isUnlocked: false),
        Badge(id: UUID(), name: "Holy Grail", description: "Visit 1000 churches", iconName: "trophy.fill", requirement: 1000, isUnlocked: false),
        Badge(id: UUID(), name: "Historian", description: "Visit 5 historic churches", iconName: "book.closed.fill", requirement: 5, isUnlocked: true),
        Badge(id: UUID(), name: "Streak Master", description: "Maintain a 7-day streak", iconName: "flame.fill", requirement: 7, isUnlocked: true),
        Badge(id: UUID(), name: "Weekend Warrior", description: "Visit churches 4 weekends in a row", iconName: "calendar", requirement: 4, isUnlocked: false),
        Badge(id: UUID(), name: "Coast to Coast", description: "Visit churches in 5 states", iconName: "map.fill", requirement: 5, isUnlocked: false),
        Badge(id: UUID(), name: "Denomination Explorer", description: "Visit 5 different denominations", iconName: "star.fill", requirement: 5, isUnlocked: true),
        Badge(id: UUID(), name: "Early Bird", description: "Check in before 8 AM", iconName: "sunrise.fill", requirement: 1, isUnlocked: false),
    ]
}
