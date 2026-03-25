import Foundation

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
        try? await Task.sleep(for: .milliseconds(500))
        entries = LeaderboardEntry.mockList
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
