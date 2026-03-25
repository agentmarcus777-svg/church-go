import SwiftUI

struct CheckInCelebrationView: View {
    let church: Church
    var reward: GamificationService.CheckInReward = .init()
    var didLevelUp: Bool = false

    @Environment(\.dismiss) private var dismiss
    @State private var confettiCounter = 0
    @State private var showContent = false
    @State private var showXP = false
    @State private var showBreakdown = false
    @State private var showButton = false
    @State private var pulseScale: CGFloat = 0.5
    @State private var backgroundOpacity: CGFloat = 0

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.cgCrimson, Color.cgDeepRed],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(backgroundOpacity)

            // Confetti
            ConfettiCannon(
                counter: $confettiCounter,
                num: 80,
                colors: [.cgGold, .cgCrimson, .white, Color(hex: 0xD4AF37)],
                confettiSize: 10,
                rainHeight: 800,
                radius: 400
            )

            VStack(spacing: Theme.spacingXL) {
                Spacer()

                if showContent {
                    // Success checkmark
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.15))
                            .frame(width: 160, height: 160)
                            .scaleEffect(pulseScale)

                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 200, height: 200)
                            .scaleEffect(pulseScale * 0.9)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundStyle(.white)
                            .scaleEffect(showContent ? 1.0 : 0.3)
                    }
                    .transition(.scale.combined(with: .opacity))

                    // Church name
                    VStack(spacing: 8) {
                        Text("Checked In!")
                            .font(AppFont.largeTitle)
                            .foregroundStyle(.white)

                        Text(church.name)
                            .font(AppFont.title3)
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if showXP {
                    // XP earned
                    XPCounter(
                        xp: reward.totalXP,
                        prefix: "+",
                        textColor: .cgGold,
                        fontSize: AppFont.xpDisplay
                    )
                    .transition(.scale.combined(with: .opacity))
                }

                if showBreakdown {
                    // Reward breakdown
                    VStack(spacing: 8) {
                        ForEach(reward.breakdown, id: \.0) { item in
                            HStack {
                                Text(item.0)
                                    .font(AppFont.callout)
                                    .foregroundStyle(.white.opacity(0.7))
                                Spacer()
                                Text("+\(item.1) XP")
                                    .font(AppFont.headline)
                                    .foregroundStyle(Color.cgGold)
                            }
                        }
                    }
                    .padding(Theme.cardPadding)
                    .background(.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMD, style: .continuous))
                    .padding(.horizontal, Theme.spacingXL)
                    .transition(.move(edge: .bottom).combined(with: .opacity))

                    if didLevelUp {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 24))
                            Text("Level Up!")
                                .font(AppFont.title2)
                        }
                        .foregroundStyle(Color.cgGold)
                        .transition(.scale.combined(with: .opacity))
                    }
                }

                Spacer()

                if showButton {
                    ChunkyButton(title: "Continue", icon: "arrow.right", style: .gold) {
                        dismiss()
                    }
                    .padding(.horizontal, Theme.spacingLG)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.bottom, Theme.spacingXL)
        }
        .onAppear {
            startCelebration()
        }
    }

    private func startCelebration() {
        // Background fade
        withAnimation(.easeIn(duration: 0.3)) {
            backgroundOpacity = 1.0
        }

        // Confetti
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            confettiCounter += 1
        }

        // Content
        withAnimation(Theme.bounceAnimation.delay(0.3)) {
            showContent = true
        }

        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            pulseScale = 1.0
        }

        // Pulse animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.1
            }
        }

        // XP
        withAnimation(Theme.bounceAnimation.delay(0.8)) {
            showXP = true
        }

        // Breakdown
        withAnimation(Theme.springAnimation.delay(1.3)) {
            showBreakdown = true
        }

        // Second confetti burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            confettiCounter += 1
        }

        // Button
        withAnimation(Theme.springAnimation.delay(1.8)) {
            showButton = true
        }
    }
}

