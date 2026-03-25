import SwiftUI

struct ChurchDetailView: View {
    let church: Church
    var isVisited: Bool = false
    @StateObject private var checkInVM = CheckInViewModel.preview
    @Environment(\.dismiss) private var dismiss
    @State private var showCheckInCelebration = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero image
                    ZStack(alignment: .bottomLeading) {
                        LinearGradient(
                            colors: [Color.cgCrimson.opacity(0.3), Color.cgDeepRed.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 260)
                        .overlay {
                            Image(systemName: "building.columns.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(.white.opacity(0.3))
                        }

                        // Gradient overlay
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        // Title overlay
                        VStack(alignment: .leading, spacing: 6) {
                            if church.isHistoric {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .font(.system(size: 11))
                                    Text("Historic Landmark")
                                        .font(AppFont.caption)
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(Color.cgGold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.cgGold.opacity(0.2))
                                .clipShape(Capsule())
                            }

                            Text(church.name)
                                .font(AppFont.title)
                                .foregroundStyle(.white)

                            Text(church.denomination)
                                .font(AppFont.callout)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(Theme.spacingLG)
                    }

                    VStack(spacing: Theme.spacingLG) {
                        // Visit status
                        if isVisited {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(Color.cgSuccess)
                                Text("You've visited this church!")
                                    .font(AppFont.headline)
                                    .foregroundStyle(Color.cgSuccess)
                                Spacer()
                            }
                            .padding(Theme.cardPadding)
                            .background(Color.cgSuccess.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMD, style: .continuous))
                        }

                        // Info cards
                        VStack(spacing: 12) {
                            InfoRow(icon: "mappin.circle.fill", title: "Address", value: church.address, color: .cgCrimson)
                            InfoRow(icon: "cross.fill", title: "Denomination", value: church.denomination, color: .cgGold)
                            InfoRow(icon: "person.2.fill", title: "Visitors", value: "\(church.visitCount) check-ins", color: .cgCrimson)
                        }
                        .cardStyle()

                        // XP breakdown
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Check-In Rewards")
                                .font(AppFont.headline)
                                .foregroundStyle(Color.cgCharcoal)

                            HStack(spacing: 16) {
                                RewardChip(label: "Base", xp: 50, icon: "checkmark.circle")
                                if !isVisited {
                                    RewardChip(label: "New", xp: 100, icon: "sparkles")
                                }
                                if church.isHistoric {
                                    RewardChip(label: "Historic", xp: 50, icon: "clock.fill")
                                }
                            }
                        }
                        .cardStyle()

                        // Check-in button
                        if !isVisited {
                            ChunkyButton(
                                title: "Check In",
                                icon: "checkmark.circle.fill",
                                style: .primary,
                                isLoading: checkInVM.isCheckingIn
                            ) {
                                Task {
                                    await checkInVM.performCheckIn(at: church)
                                    showCheckInCelebration = true
                                }
                            }
                        } else {
                            ChunkyButton(title: "Share Visit", icon: "square.and.arrow.up", style: .secondary) {
                                // Share action
                            }
                        }
                    }
                    .padding(Theme.spacingLG)
                }
            }
            .background(Color.cgBackground)
            .ignoresSafeArea(edges: .top)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white)
                    }
                }
            }
            .fullScreenCover(isPresented: $showCheckInCelebration) {
                CheckInCelebrationView(
                    church: church,
                    reward: checkInVM.reward ?? .init(),
                    didLevelUp: checkInVM.didLevelUp
                )
            }
        }
    }
}

// MARK: - Info Row

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    var color: Color = .cgCrimson

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(AppFont.caption)
                    .foregroundStyle(Color.cgSecondaryText)
                Text(value)
                    .font(AppFont.body)
                    .foregroundStyle(Color.cgCharcoal)
            }

            Spacer()
        }
    }
}

// MARK: - Reward Chip

private struct RewardChip: View {
    let label: String
    let xp: Int
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(Color.cgGold)

            Text("+\(xp)")
                .font(AppFont.headline)
                .foregroundStyle(Color.cgCharcoal)

            Text(label)
                .font(AppFont.caption2)
                .foregroundStyle(Color.cgSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.cgGold.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMD, style: .continuous))
    }
}

#Preview {
    ChurchDetailView(church: .mock, isVisited: false)
}
