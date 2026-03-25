import SwiftUI

struct OnboardingView: View {
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
            icon: "flame.fill",
            title: "Build Your Streak",
            subtitle: "Visit churches daily to maintain your streak. Follow in His footsteps.",
            color: .cgDeepRed
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
                        ChunkyButton(title: "Get Started", icon: "arrow.right", style: .primary) {
                            onComplete()
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
}

// MARK: - Page Model

private struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
}

