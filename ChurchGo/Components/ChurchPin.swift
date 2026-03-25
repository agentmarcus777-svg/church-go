import SwiftUI

struct ChurchPin: View {
    var isVisited: Bool
    var isSelected: Bool = false

    @State private var bounce: Bool = false

    private var pinColor: Color {
        isVisited ? .cgGold : .cgCrimson
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Pin body
                Circle()
                    .fill(pinColor)
                    .frame(width: 44, height: 44)
                    .shadow(color: pinColor.opacity(0.4), radius: isSelected ? 8 : 4, y: 2)

                // Church icon
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                // Checkmark for visited
                if isVisited {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .background(Circle().fill(Color.cgSuccess).padding(-1))
                        .offset(x: 14, y: -14)
                }
            }

            // Pin point
            Triangle()
                .fill(pinColor)
                .frame(width: 14, height: 8)
                .offset(y: -1)
        }
        .scaleEffect(isSelected ? 1.2 : (bounce ? 1.05 : 1.0))
        .offset(y: isSelected ? -8 : 0)
        .animation(Theme.springAnimation, value: isSelected)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
            ) {
                bounce = true
            }
        }
    }
}

// MARK: - Triangle Shape

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

