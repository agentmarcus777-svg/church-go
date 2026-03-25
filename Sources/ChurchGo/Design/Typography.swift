import SwiftUI

enum AppFont {
    // MARK: - SF Rounded Weights

    static func rounded(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    // MARK: - Named Styles

    /// 34pt Bold — Screen titles
    static let largeTitle = rounded(size: 34, weight: .bold)

    /// 28pt Bold — Section headers
    static let title = rounded(size: 28, weight: .bold)

    /// 22pt Semibold — Card titles
    static let title2 = rounded(size: 22, weight: .semibold)

    /// 20pt Semibold — Sub-headers
    static let title3 = rounded(size: 20, weight: .semibold)

    /// 17pt Semibold — Emphasized body
    static let headline = rounded(size: 17, weight: .semibold)

    /// 17pt Regular — Standard body text
    static let body = rounded(size: 17, weight: .regular)

    /// 16pt Regular — Secondary content
    static let callout = rounded(size: 16, weight: .regular)

    /// 15pt Regular — Supplementary text
    static let subheadline = rounded(size: 15, weight: .regular)

    /// 13pt Regular — Footnotes & captions
    static let footnote = rounded(size: 13, weight: .regular)

    /// 12pt Regular — Small labels
    static let caption = rounded(size: 12, weight: .regular)

    /// 11pt Regular — Tiny labels
    static let caption2 = rounded(size: 11, weight: .regular)

    // MARK: - Special Styles

    /// 60pt Heavy — XP counter display
    static let xpDisplay = rounded(size: 60, weight: .heavy)

    /// 48pt Bold — Level number
    static let levelDisplay = rounded(size: 48, weight: .bold)

    /// 24pt Bold — Stat numbers
    static let statNumber = rounded(size: 24, weight: .bold)

    /// 14pt Semibold — Button labels
    static let button = rounded(size: 17, weight: .bold)

    /// 18pt Bold — Tab bar highlight
    static let tabLabel = rounded(size: 10, weight: .semibold)
}

// MARK: - View Extension for easy use

extension View {
    func appFont(_ font: Font) -> some View {
        self.font(font)
    }
}
