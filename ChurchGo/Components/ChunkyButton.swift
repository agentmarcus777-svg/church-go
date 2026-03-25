import SwiftUI

struct ChunkyButton: View {
    let title: String
    var icon: String? = nil
    var style: ButtonStyle = .primary
    var isLoading: Bool = false
    let action: () -> Void

    enum ButtonStyle {
        case primary, secondary, gold, destructive

        var backgroundColor: Color {
            switch self {
            case .primary: return .cgCrimson
            case .secondary: return .cgCharcoal
            case .gold: return .cgGold
            case .destructive: return .cgDeepRed
            }
        }

        var foregroundColor: Color {
            switch self {
            case .gold: return .cgCharcoal
            default: return .white
            }
        }

        var shadowColor: Color {
            switch self {
            case .primary: return .cgDeepRed
            case .secondary: return .black.opacity(0.3)
            case .gold: return Color(hex: 0xB8860B)
            case .destructive: return .black.opacity(0.3)
            }
        }
    }

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .tint(style.foregroundColor)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .bold))
                    }
                    Text(title)
                        .font(AppFont.button)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Theme.buttonHeight)
            .foregroundStyle(style.foregroundColor)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Theme.buttonRadius, style: .continuous))
            .shadow(color: style.shadowColor.opacity(0.5), radius: 0, x: 0, y: isPressed ? 2 : 5)
            .offset(y: isPressed ? 3 : 0)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(Theme.quickSpring) { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation(Theme.quickSpring) { isPressed = false }
                }
        )
        .disabled(isLoading)
    }
}

