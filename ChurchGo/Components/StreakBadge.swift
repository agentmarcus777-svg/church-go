import SwiftUI

struct StreakBadge: View {
    let streak: Int
    var size: StreakSize = .medium

    enum StreakSize: Equatable {
        case small, medium, large

        var iconSize: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 24
            case .large: return 40
            }
        }

        var font: Font {
            switch self {
            case .small: return AppFont.caption
            case .medium: return AppFont.title3
            case .large: return AppFont.title
            }
        }

        var padding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }
    }

    @State private var flameScale: CGFloat = 1.0
    @State private var flameOffset: CGFloat = 0

    var body: some View {
        HStack(spacing: 6) {
            Text("🔥")
                .font(.system(size: size.iconSize))
                .scaleEffect(flameScale)
                .offset(y: flameOffset)

            Text("\(streak)")
                .font(size.font)
                .fontWeight(.bold)
                .foregroundStyle(streak > 0 ? Color.cgCrimson : Color.cgSecondaryText)

            if size != .small {
                Text(streak == 1 ? "day" : "days")
                    .font(AppFont.caption)
                    .foregroundStyle(Color.cgSecondaryText)
            }
        }
        .padding(.horizontal, size.padding)
        .padding(.vertical, size.padding * 0.6)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusMD, style: .continuous)
                .fill(Color.cgCrimson.opacity(0.1))
        )
        .onAppear {
            guard streak > 0 else { return }
            startFlameAnimation()
        }
    }

    private func startFlameAnimation() {
        withAnimation(
            .easeInOut(duration: 0.8)
            .repeatForever(autoreverses: true)
        ) {
            flameScale = 1.15
            flameOffset = -2
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        StreakBadge(streak: 7, size: .large)
        StreakBadge(streak: 14, size: .medium)
        StreakBadge(streak: 3, size: .small)
        StreakBadge(streak: 0, size: .medium)
    }
    .padding()
    .background(Color.cgBackground)
}
