import SwiftUI

struct ShimmerCard: View {
    var height: CGFloat = 120

    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title placeholder
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.cgCharcoal.opacity(0.08))
                .frame(width: 180, height: 18)

            // Subtitle placeholder
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.cgCharcoal.opacity(0.06))
                .frame(width: 120, height: 14)

            Spacer()

            // Bottom row
            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.cgCharcoal.opacity(0.06))
                    .frame(width: 80, height: 14)
                Spacer()
                Circle()
                    .fill(Color.cgCharcoal.opacity(0.08))
                    .frame(width: 32, height: 32)
            }
        }
        .padding(Theme.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: height)
        .background(Color.cgSurface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        .modifier(CardShadowModifier())
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear,
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: shimmerOffset * 400)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        )
        .onAppear {
            withAnimation(
                .linear(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                shimmerOffset = 1
            }
        }
    }
}

