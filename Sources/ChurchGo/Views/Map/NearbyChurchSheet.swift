import SwiftUI

struct NearbyChurchSheet: View {
    let churches: [Church]
    var visitedIDs: Set<UUID> = []
    var onSelect: (Church) -> Void = { _ in }

    @State private var sheetOffset: CGFloat = 0
    private let minHeight: CGFloat = 180
    private let maxHeight: CGFloat = 420

    var body: some View {
        VStack(spacing: 0) {
            // Handle
            Capsule()
                .fill(Color.cgCharcoal.opacity(0.15))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 12)

            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Nearby")
                        .font(AppFont.title2)
                        .foregroundStyle(Color.cgCharcoal)
                    Text("\(churches.count) churches found")
                        .font(AppFont.caption)
                        .foregroundStyle(Color.cgSecondaryText)
                }
                Spacer()
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.cgCrimson)
            }
            .padding(.horizontal, Theme.spacingMD)
            .padding(.bottom, Theme.spacingSM)

            // Church list
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(churches) { church in
                        NearbyChurchCard(
                            church: church,
                            isVisited: visitedIDs.contains(church.id)
                        )
                        .onTapGesture {
                            onSelect(church)
                            let gen = UIImpactFeedbackGenerator(style: .light)
                            gen.impactOccurred()
                        }
                    }
                }
                .padding(.horizontal, Theme.spacingMD)
                .padding(.bottom, Theme.spacingMD)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Theme.radiusXL, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 20, y: -5)
        )
    }
}

// MARK: - Church Card

struct NearbyChurchCard: View {
    let church: Church
    var isVisited: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Photo placeholder
            ZStack {
                RoundedRectangle(cornerRadius: Theme.radiusMD, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: isVisited
                                ? [Color.cgGold.opacity(0.3), Color.cgGold.opacity(0.1)]
                                : [Color.cgCrimson.opacity(0.2), Color.cgCrimson.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 80)

                Image(systemName: "building.columns.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(isVisited ? Color.cgGold : Color.cgCrimson.opacity(0.5))

                if isVisited {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.cgSuccess)
                                .padding(6)
                        }
                        Spacer()
                    }
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(church.name)
                    .font(AppFont.headline)
                    .foregroundStyle(Color.cgCharcoal)
                    .lineLimit(1)

                Text(church.denomination)
                    .font(AppFont.caption)
                    .foregroundStyle(Color.cgSecondaryText)

                if church.isHistoric {
                    HStack(spacing: 3) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 9))
                        Text("Historic")
                            .font(AppFont.caption2)
                    }
                    .foregroundStyle(Color.cgGold)
                }
            }
        }
        .frame(width: 180)
        .padding(10)
        .background(Color.cgSurface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        .modifier(CardShadowModifier())
    }
}

#Preview {
    ZStack {
        Color.cgBackground.ignoresSafeArea()
        VStack {
            Spacer()
            NearbyChurchSheet(
                churches: Church.mockList,
                visitedIDs: [Church.mockList[0].id]
            )
        }
    }
}
