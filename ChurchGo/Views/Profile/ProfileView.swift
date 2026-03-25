import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel.preview

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.spacingLG) {
                    // Profile header
                    profileHeader

                    // Stats grid
                    statsGrid

                    // Badge section
                    badgeSection

                    // Recent activity
                    recentSection
                }
                .padding(.horizontal, Theme.spacingMD)
                .padding(.bottom, Theme.spacingXXL)
            }
            .background(Color.cgBackground)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.cgCharcoal)
                    }
                }
            }
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        VStack(spacing: Theme.spacingMD) {
            // Avatar with level ring
            ZStack {
                ProgressRing(
                    progress: viewModel.user.levelProgress,
                    lineWidth: 6,
                    size: 110,
                    gradientColors: [.cgGold, .cgCrimson]
                )

                // Avatar placeholder
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.cgCrimson, .cgDeepRed],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .overlay {
                        Text(String(viewModel.user.displayName.prefix(1)))
                            .font(AppFont.levelDisplay)
                            .foregroundStyle(.white)
                    }

                // Level badge
                VStack {
                    Spacer()
                    Text("Lv.\(viewModel.user.level)")
                        .font(AppFont.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.cgCrimson)
                        .clipShape(Capsule())
                        .offset(y: 8)
                }
                .frame(height: 110)
            }

            VStack(spacing: 4) {
                Text(viewModel.user.displayName)
                    .font(AppFont.title)
                    .foregroundStyle(Color.cgCharcoal)

                Text(viewModel.levelTitle)
                    .font(AppFont.callout)
                    .foregroundStyle(Color.cgSecondaryText)
            }

            StreakBadge(streak: viewModel.user.streak, size: .medium)
        }
        .padding(.top, Theme.spacingMD)
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ], spacing: 12) {
            ForEach(viewModel.stats, id: \.1) { stat in
                VStack(spacing: 8) {
                    Image(systemName: stat.0)
                        .font(.system(size: 22))
                        .foregroundStyle(Color.cgCrimson)

                    Text(stat.1)
                        .font(AppFont.statNumber)
                        .foregroundStyle(Color.cgCharcoal)

                    Text(stat.2)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.cgSecondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.spacingMD)
                .background(Color.cgSurface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
                .modifier(CardShadowModifier())
            }
        }
    }

    // MARK: - Badge Section

    private var badgeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Badges")
                    .font(AppFont.title2)
                    .foregroundStyle(Color.cgCharcoal)
                Spacer()
                NavigationLink {
                    BadgesView()
                } label: {
                    Text("See All")
                        .font(AppFont.callout)
                        .foregroundStyle(Color.cgCrimson)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.badges.prefix(6)) { badge in
                        BadgeMiniCard(badge: badge)
                    }
                }
            }
        }
    }

    // MARK: - Recent Section

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Visits")
                .font(AppFont.title2)
                .foregroundStyle(Color.cgCharcoal)

            ForEach(Church.mockList.prefix(3)) { church in
                HStack(spacing: 12) {
                    Image(systemName: "building.columns.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.cgGold)
                        .frame(width: 40, height: 40)
                        .background(Color.cgGold.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(church.name)
                            .font(AppFont.headline)
                            .foregroundStyle(Color.cgCharcoal)
                            .lineLimit(1)
                        Text("Today")
                            .font(AppFont.caption)
                            .foregroundStyle(Color.cgSecondaryText)
                    }

                    Spacer()

                    XPBadge(xp: 150)
                }
                .cardStyle()
            }
        }
    }
}

// MARK: - Badge Mini Card

struct BadgeMiniCard: View {
    let badge: Badge

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.isUnlocked ? Color.cgGold.opacity(0.15) : Color.cgCharcoal.opacity(0.05))
                    .frame(width: 56, height: 56)

                Image(systemName: badge.iconName)
                    .font(.system(size: 24))
                    .foregroundStyle(badge.isUnlocked ? Color.cgGold : Color.cgSecondaryText.opacity(0.4))
            }

            Text(badge.name)
                .font(AppFont.caption2)
                .foregroundStyle(badge.isUnlocked ? Color.cgCharcoal : Color.cgSecondaryText)
                .lineLimit(1)
        }
        .frame(width: 80)
        .opacity(badge.isUnlocked ? 1.0 : 0.5)
    }
}

