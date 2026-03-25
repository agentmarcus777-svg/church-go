import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel.preview

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter picker
                Picker("Time Filter", selection: $viewModel.selectedFilter) {
                    ForEach(LeaderboardViewModel.TimeFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Theme.spacingMD)
                .padding(.vertical, Theme.spacingSM)

                ScrollView {
                    VStack(spacing: 0) {
                        // Top 3 podium
                        if viewModel.entries.count >= 3 {
                            podiumView
                                .padding(.vertical, Theme.spacingLG)
                        }

                        // Full list
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.entries) { entry in
                                LeaderboardRow(
                                    entry: entry,
                                    isCurrentUser: entry.rank == viewModel.currentUserRank
                                )
                            }
                        }
                        .padding(.horizontal, Theme.spacingMD)
                        .padding(.bottom, Theme.spacingXXL)
                    }
                }
            }
            .background(Color.cgBackground)
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadLeaderboard()
            }
        }
    }

    // MARK: - Podium View

    private var podiumView: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if viewModel.entries.count >= 3 {
                // 2nd place
                PodiumCard(entry: viewModel.entries[1], height: 100, color: .cgSecondaryText)

                // 1st place
                PodiumCard(entry: viewModel.entries[0], height: 130, color: .cgGold)
                    .overlay(alignment: .top) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.cgGold)
                            .offset(y: -28)
                    }

                // 3rd place
                PodiumCard(entry: viewModel.entries[2], height: 80, color: Color(hex: 0xCD7F32))
            }
        }
        .padding(.horizontal, Theme.spacingLG)
    }
}

// MARK: - Podium Card

private struct PodiumCard: View {
    let entry: LeaderboardEntry
    let height: CGFloat
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [color, color.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 48, height: 48)
                .overlay {
                    Text(String(entry.displayName.prefix(1)))
                        .font(AppFont.title3)
                        .foregroundStyle(.white)
                }

            Text(entry.displayName)
                .font(AppFont.caption)
                .foregroundStyle(Color.cgCharcoal)
                .lineLimit(1)

            Text("\(entry.xp) XP")
                .font(AppFont.caption2)
                .fontWeight(.bold)
                .foregroundStyle(color)

            // Podium block
            RoundedRectangle(cornerRadius: Theme.radiusMD, style: .continuous)
                .fill(color.opacity(0.15))
                .frame(height: height)
                .overlay {
                    Text("#\(entry.rank)")
                        .font(AppFont.title2)
                        .foregroundStyle(color)
                }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Leaderboard Row

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    var isCurrentUser: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            // Rank
            Text("#\(entry.rank)")
                .font(AppFont.headline)
                .foregroundStyle(rankColor)
                .frame(width: 36)

            // Avatar
            Circle()
                .fill(isCurrentUser
                    ? LinearGradient(colors: [.cgCrimson, .cgDeepRed], startPoint: .topLeading, endPoint: .bottomTrailing)
                    : LinearGradient(colors: [Color.cgSecondaryText.opacity(0.3), Color.cgSecondaryText.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(width: 40, height: 40)
                .overlay {
                    Text(String(entry.displayName.prefix(1)))
                        .font(AppFont.headline)
                        .foregroundStyle(isCurrentUser ? .white : Color.cgCharcoal)
                }

            // Info
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(entry.displayName)
                        .font(AppFont.headline)
                        .foregroundStyle(Color.cgCharcoal)
                    if isCurrentUser {
                        Text("You")
                            .font(AppFont.caption2)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.cgCrimson)
                            .clipShape(Capsule())
                    }
                }
                Text("Level \(entry.level)")
                    .font(AppFont.caption)
                    .foregroundStyle(Color.cgSecondaryText)
            }

            Spacer()

            // XP
            Text("\(entry.xp)")
                .font(AppFont.headline)
                .foregroundStyle(Color.cgGold)
            Text("XP")
                .font(AppFont.caption)
                .foregroundStyle(Color.cgSecondaryText)
        }
        .padding(Theme.cardPadding)
        .background(isCurrentUser ? Color.cgCrimson.opacity(0.05) : Color.cgSurface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous)
                .stroke(isCurrentUser ? Color.cgCrimson.opacity(0.3) : .clear, lineWidth: 2)
        )
        .modifier(CardShadowModifier())
    }

    private var rankColor: Color {
        switch entry.rank {
        case 1: return .cgGold
        case 2: return Color.cgSecondaryText
        case 3: return Color(hex: 0xCD7F32)
        default: return Color.cgSecondaryText
        }
    }
}

#Preview {
    LeaderboardView()
}
