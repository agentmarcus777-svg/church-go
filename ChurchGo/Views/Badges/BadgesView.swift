import SwiftUI

struct BadgesView: View {
    let badges: [Badge] = Badge.mockList

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    private var unlockedBadges: [Badge] {
        badges.filter(\.isUnlocked)
    }

    private var lockedBadges: [Badge] {
        badges.filter { !$0.isUnlocked }
    }

    private var unlockedProgress: Double {
        guard !badges.isEmpty else { return 0 }
        return Double(unlockedBadges.count) / Double(badges.count)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.spacingLG) {
                summarySection
                badgeSection(title: "Unlocked", titleColor: .cgCharcoal, items: unlockedBadges)
                badgeSection(title: "Locked", titleColor: .cgSecondaryText, items: lockedBadges)
            }
            .padding(Theme.spacingMD)
            .padding(.bottom, Theme.spacingXXL)
        }
        .background(Color.cgBackground)
        .navigationTitle("Badges")
        .navigationBarTitleDisplayMode(.large)
    }

    private var summarySection: some View {
        HStack(spacing: Theme.spacingMD) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(unlockedBadges.count)")
                    .font(AppFont.levelDisplay)
                    .foregroundStyle(Color.cgGold)
                Text("of \(badges.count) unlocked")
                    .font(AppFont.callout)
                    .foregroundStyle(Color.cgSecondaryText)
            }

            Spacer()

            ProgressRing(
                progress: unlockedProgress,
                lineWidth: 8,
                size: 70,
                gradientColors: [.cgGold, .cgCrimson]
            )
            .overlay {
                Text("\(Int(unlockedProgress * 100))%")
                    .font(AppFont.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.cgCharcoal)
            }
        }
        .cardStyle()
    }

    @ViewBuilder
    private func badgeSection(title: String, titleColor: Color, items: [Badge]) -> some View {
        Text(title)
            .font(AppFont.title2)
            .foregroundStyle(titleColor)

        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items) { badge in
                BadgeCard(badge: badge)
            }
        }
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
