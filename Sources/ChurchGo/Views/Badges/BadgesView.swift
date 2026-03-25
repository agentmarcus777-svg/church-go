import SwiftUI

struct BadgesView: View {
    let badges: [Badge] = Badge.mockList

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.spacingLG) {
                // Summary
                HStack(spacing: Theme.spacingMD) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(badges.filter(\.isUnlocked).count)")
                            .font(AppFont.levelDisplay)
                            .foregroundStyle(Color.cgGold)
                        Text("of \(badges.count) unlocked")
                            .font(AppFont.callout)
                            .foregroundStyle(Color.cgSecondaryText)
                    }

                    Spacer()

                    ProgressRing(
                        progress: Double(badges.filter(\.isUnlocked).count) / Double(badges.count),
                        lineWidth: 8,
                        size: 70,
                        gradientColors: [.cgGold, .cgCrimson]
                    )
                    .overlay {
                        Text("\(Int(Double(badges.filter(\.isUnlocked).count) / Double(badges.count) * 100))%")
                            .font(AppFont.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.cgCharcoal)
                    }
                }
                .cardStyle()

                // Unlocked
                Text("Unlocked")
                    .font(AppFont.title2)
                    .foregroundStyle(Color.cgCharcoal)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(badges.filter(\.isUnlocked)) { badge in
                        BadgeCard(badge: badge)
                    }
                }

                // Locked
                Text("Locked")
                    .font(AppFont.title2)
                    .foregroundStyle(Color.cgSecondaryText)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(badges.filter { !$0.isUnlocked }) { badge in
                        BadgeCard(badge: badge)
                    }
                }
            }
            .padding(Theme.spacingMD)
            .padding(.bottom, Theme.spacingXXL)
        }
        .background(Color.cgBackground)
        .navigationTitle("Badges")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Badge Card

struct BadgeCard: View {
    let badge: Badge
    @State private var showDetail = false

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(badge.isUnlocked
                        ? LinearGradient(colors: [Color.cgGold.opacity(0.2), Color.cgGold.opacity(0.05)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing)
                        : LinearGradient(colors: [Color.cgCharcoal.opacity(0.08), Color.cgCharcoal.opacity(0.03)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 70, height: 70)

                Image(systemName: badge.iconName)
                    .font(.system(size: 30))
                    .foregroundStyle(badge.isUnlocked ? Color.cgGold : Color.cgSecondaryText.opacity(0.3))

                if !badge.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.cgSecondaryText.opacity(0.5))
                        .offset(x: 22, y: 22)
                }
            }

            Text(badge.name)
                .font(AppFont.caption)
                .fontWeight(.semibold)
                .foregroundStyle(badge.isUnlocked ? Color.cgCharcoal : Color.cgSecondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(badge.description)
                .font(AppFont.caption2)
                .foregroundStyle(Color.cgSecondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color.cgSurface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        .modifier(CardShadowModifier())
        .opacity(badge.isUnlocked ? 1.0 : 0.6)
    }
}

#Preview {
    NavigationStack {
        BadgesView()
    }
}
