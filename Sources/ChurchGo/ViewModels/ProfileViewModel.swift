import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: AppUser
    @Published var badges: [Badge]
    @Published var recentCheckIns: [CheckIn]
    @Published var isLoading: Bool = false

    var levelTitle: String {
        GamificationService.levelTitle(for: user.level)
    }

    var unlockedBadgeCount: Int {
        badges.filter(\.isUnlocked).count
    }

    var stats: [(String, String, String)] {
        [
            ("building.columns.fill", "\(user.totalChurches)", "Churches"),
            ("star.fill", "\(user.xp)", "Total XP"),
            ("flame.fill", "\(user.streak)", "Day Streak"),
            ("medal.fill", "\(unlockedBadgeCount)", "Badges"),
        ]
    }

    init(user: AppUser = .mock, badges: [Badge] = Badge.mockList) {
        self.user = user
        self.badges = badges
        self.recentCheckIns = []
    }

    func loadProfile() async {
        isLoading = true
        // In production, fetch from Supabase
        try? await Task.sleep(for: .milliseconds(500))
        isLoading = false
    }

    static var preview: ProfileViewModel {
        ProfileViewModel()
    }
}
