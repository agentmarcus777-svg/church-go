import SwiftUI

struct XPCounter: View {
    let xp: Int
    var prefix: String = "+"
    var textColor: Color = .cgGold
    var fontSize: Font = AppFont.statNumber

    @State private var displayedXP: Int = 0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        HStack(spacing: 4) {
            Text(prefix)
                .font(fontSize)
                .foregroundStyle(textColor)

            Text("\(displayedXP)")
                .font(fontSize)
                .foregroundStyle(textColor)
                .contentTransition(.numericText(value: Double(displayedXP)))

            Text("XP")
                .font(AppFont.headline)
                .foregroundStyle(textColor.opacity(0.8))
        }
        .scaleEffect(scale)
        .onAppear {
            animateCount()
        }
        .onChange(of: xp) { _, _ in
            animateCount()
        }
    }

    private func animateCount() {
        displayedXP = 0
        let steps = 30
        let stepDuration = 0.6 / Double(steps)

        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(i)) {
                withAnimation(.easeOut(duration: 0.05)) {
                    displayedXP = Int(Double(xp) * (Double(i) / Double(steps)))
                }
            }
        }

        // Bounce at the end
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(Theme.bounceAnimation) {
                scale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(Theme.bounceAnimation) {
                    scale = 1.0
                }
            }
        }
    }
}

// MARK: - Compact XP Badge

struct XPBadge: View {
    let xp: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 12))
            Text("\(xp) XP")
                .font(AppFont.caption)
                .fontWeight(.bold)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.cgGold)
        .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 30) {
        XPCounter(xp: 150)
        XPCounter(xp: 2450, prefix: "", textColor: .cgCrimson, fontSize: AppFont.xpDisplay)
        XPBadge(xp: 150)
    }
    .padding()
    .background(Color.cgBackground)
}
