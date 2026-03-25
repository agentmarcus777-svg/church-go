import SwiftUI

struct ProgressRing: View {
    var progress: Double
    var lineWidth: CGFloat = 12
    var size: CGFloat = 100
    var gradientColors: [Color] = [.cgGold, .cgCrimson]
    var trackColor: Color = .cgCharcoal.opacity(0.1)

    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(trackColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // Progress
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: gradientColors),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360 * animatedProgress)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            // End cap glow
            if animatedProgress > 0.05 {
                Circle()
                    .fill(gradientColors.last ?? .cgCrimson)
                    .frame(width: lineWidth, height: lineWidth)
                    .offset(y: -(size - lineWidth) / 2)
                    .rotationEffect(.degrees(360 * animatedProgress - 90))
                    .shadow(color: (gradientColors.last ?? .cgCrimson).opacity(0.5), radius: 4)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = min(progress, 1.0)
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: 0.6)) {
                animatedProgress = min(newValue, 1.0)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        ProgressRing(progress: 0.75, size: 120)
            .overlay {
                VStack(spacing: 2) {
                    Text("75%")
                        .font(AppFont.title2)
                        .foregroundStyle(Color.cgCharcoal)
                    Text("Level 12")
                        .font(AppFont.caption)
                        .foregroundStyle(Color.cgSecondaryText)
                }
            }

        HStack(spacing: 20) {
            ProgressRing(progress: 0.3, lineWidth: 8, size: 60, gradientColors: [.cgGold, .cgGold])
            ProgressRing(progress: 0.6, lineWidth: 8, size: 60)
            ProgressRing(progress: 1.0, lineWidth: 8, size: 60, gradientColors: [.cgSuccess, .cgSuccess])
        }
    }
    .padding()
    .background(Color.cgBackground)
}
