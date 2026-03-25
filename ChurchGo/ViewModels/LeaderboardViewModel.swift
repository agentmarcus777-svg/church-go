import Foundation
import Combine

@MainActor
final class LeaderboardViewModel: ObservableObject {
    enum TimeFilter: String, CaseIterable {
        case weekly = "Weekly"
        case allTime = "All Time"
    }

    @Published var selectedFilter: TimeFilter = .weekly
    @Published var entries: [LeaderboardEntry] = []
    @Published var isLoading: Bool = false
    @Published var currentUserRank: Int? = 4

    func loadLeaderboard() async {
        isLoading = true
        // In production, fetch from Supabase
        try? await Task.sleep(nanoseconds: 500_000_000)
        entries = switch selectedFilter {
        case .weekly:
            LeaderboardEntry.mockList
        case .allTime:
            LeaderboardEntry.mockList.enumerated().map { index, entry in
                LeaderboardEntry(
                    userId: entry.userId,
                    displayName: entry.displayName,
                    xp: entry.xp * 3,
                    level: min(entry.level + 4, 100),
                    rank: index + 1
                )
            }
        }
        isLoading = false
    }

    func refresh() async {
        await loadLeaderboard()
    }

    static var preview: LeaderboardViewModel {
        let vm = LeaderboardViewModel()
        vm.entries = LeaderboardEntry.mockList
        return vm
    }
}
