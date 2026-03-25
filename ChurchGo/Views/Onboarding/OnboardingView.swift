import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var locationService: LocationService
    @State private var currentPage = 0
    @State private var isAnimating = false
    var onComplete: () -> Void = {}

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "building.columns.fill",
            title: "Discover Churches",
            subtitle: "Find beautiful churches near you and around the world. Every visit is an adventure.",
            color: .cgCrimson
        ),
        OnboardingPage(
            icon: "star.fill",
            title: "Earn XP & Level Up",
            subtitle: "Check in at churches to earn points, unlock badges, and climb the leaderboard.",
            color: .cgGold
        ),
        OnboardingPage(
            icon: "location.fill",
            title: "Check In On Location",
            subtitle: "Enable location so Church Go can validate visits, unlock rewards, and guide you to the next church nearby.",
            color: .cgDeepRed,
            requiresLocation: true
        ),
    ]

    var body: some View {
        ZStack {
            Color.cgBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        VStack(spacing: Theme.spacingXL) {
                            Spacer()

                            // Icon circle
                            ZStack {
                                Circle()
                                    .fill(page.color.opacity(0.15))
                                    .frame(width: 180, height: 180)

                                Circle()
                                    .fill(page.color.opacity(0.08))
                                    .frame(width: 240, height: 240)
                                    .scaleEffect(isAnimating ? 1.1 : 1.0)

                                Image(systemName: page.icon)
                                    .font(.system(size: 70, weight: .bold))
                                    .foregroundStyle(page.color)
                                    .scaleEffect(isAnimating ? 1.05 : 0.95)
                            }
                            .onAppear {
                                withAnimation(
                                    .easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true)
                                ) {
                                    isAnimating = true
                                }
                            }

                            VStack(spacing: Theme.spacingMD) {
                                Text(page.title)
                                    .font(AppFont.largeTitle)
                                    .foregroundStyle(Color.cgCharcoal)
                                    .multilineTextAlignment(.center)

                                Text(page.subtitle)
                                    .font(AppFont.body)
                                    .foregroundStyle(Color.cgSecondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, Theme.spacingXL)

                                if page.requiresLocation {
                                    locationStatusCard
                                        .padding(.horizontal, Theme.spacingLG)
                                }
                            }

                            Spacer()
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Bottom controls
                VStack(spacing: Theme.spacingLG) {
                    // Custom page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? Color.cgCrimson : Color.cgCrimson.opacity(0.2))
                                .frame(width: index == currentPage ? 24 : 8, height: 8)
                                .animation(Theme.springAnimation, value: currentPage)
                        }
                    }

                    if currentPage == pages.count - 1 {
                        ChunkyButton(
                            title: locationService.authorizationStatus == .notDetermined ? "Enable Location" : "Start Exploring",
                            icon: "arrow.right",
                            style: .primary
                        ) {
                            handleFinalStep()
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        ChunkyButton(title: "Continue", style: .primary) {
                            withAnimation(Theme.springAnimation) {
                                currentPage += 1
                            }
                        }
                    }

                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(AppFont.callout)
                        .foregroundStyle(Color.cgSecondaryText)
                    }
                }
                .padding(.horizontal, Theme.spacingLG)
                .padding(.bottom, Theme.spacingXL)
            }
        }
    }

    private var locationStatusCard: some View {
        HStack(spacing: 12) {
            Image(systemName: locationIcon)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.cgGold)
                .frame(width: 42, height: 42)
                .background(Color.cgGold.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMD, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(locationTitle)
                    .font(AppFont.headline)
                    .foregroundStyle(Color.cgCharcoal)
                Text(locationSubtitle)
                    .font(AppFont.caption)
                    .foregroundStyle(Color.cgSecondaryText)
            }

            Spacer()
        }
        .padding(Theme.cardPadding)
        .background(Color.cgSurface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLG, style: .continuous))
        .modifier(CardShadowModifier())
    }

    private var locationIcon: String {
        switch locationService.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return "location.fill"
        case .denied, .restricted:
            return "location.slash.fill"
        default:
            return "location.circle.fill"
        }
    }

    private var locationTitle: String {
        switch locationService.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return "Location Ready"
        case .denied, .restricted:
            return "Location Disabled"
        default:
            return "Permission Needed"
        }
    }

    private var locationSubtitle: String {
        switch locationService.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return "Church check-ins and nearby church discovery are enabled."
        case .denied, .restricted:
            return "You can still browse, but on-site check-ins stay locked until location access is restored in Settings."
        default:
            return "Church Go uses your location only to verify nearby visits and show churches around you."
        }
    }

    private func handleFinalStep() {
        if locationService.authorizationStatus == .notDetermined {
            locationService.requestPermission()
        }

        onComplete()
    }
}

// MARK: - Page Model

private struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var requiresLocation: Bool = false
}

#Preview {
    OnboardingView()
        .environmentObject(LocationService())
}
