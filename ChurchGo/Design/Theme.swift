import SwiftUI

enum Theme {
    // MARK: - Spacing

    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 16
    static let spacingLG: CGFloat = 24
    static let spacingXL: CGFloat = 32
    static let spacingXXL: CGFloat = 48

    // MARK: - Corner Radius

    static let radiusSM: CGFloat = 8
    static let radiusMD: CGFloat = 12
    static let radiusLG: CGFloat = 16
    static let radiusXL: CGFloat = 24
    static let radiusFull: CGFloat = 999

    // MARK: - Button

    static let buttonHeight: CGFloat = 56
    static let buttonRadius: CGFloat = 16

    // MARK: - Card

    static let cardRadius: CGFloat = 16
    static let cardPadding: CGFloat = 16

    // MARK: - Shadows

    static var cardShadow: some View {
        Color.black.opacity(0.08)
    }

    static func cardShadowStyle() -> some ViewModifier {
        CardShadowModifier()
    }

    // MARK: - Animation

    static let springAnimation: Animation = .spring(response: 0.5, dampingFraction: 0.7)
    static let quickSpring = Animation.spring(response: 0.3, dampingFraction: 0.8)
    static let bounceAnimation = Animation.spring(response: 0.5, dampingFraction: 0.6)
}

// MARK: - Card Shadow Modifier

struct CardShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
            .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Card Style Modifier

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Theme.cardPadding)
            .background(Color.cgSurface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
            .modifier(CardShadowModifier())
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
