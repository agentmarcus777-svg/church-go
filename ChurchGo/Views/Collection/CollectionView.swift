import SwiftUI

struct CollectionView: View {
    @State private var selectedScope: FilterScope = .all
    @State private var selectedValue: String = FilterScope.allValue
    @State private var selectedSort: SortOption = .recent

    private let stamps = VisitStamp.sampleData
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.spacingLG) {
                    headerCard
                    filtersCard

                    if filteredStamps.isEmpty {
                        emptyState
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredStamps) { stamp in
                                PassportStampCard(stamp: stamp)
                            }
                        }
                    }
                }
                .padding(Theme.spacingMD)
                .padding(.bottom, Theme.spacingXXL)
            }
            .background(Color.cgBackground)
            .navigationTitle("Collection")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerCard: some View {
        HStack(alignment: .bottom, spacing: Theme.spacingMD) {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(filteredStamps.count)")
                    .font(AppFont.levelDisplay)
                    .foregroundStyle(Color.cgCrimson)

                Text(filteredStamps.count == 1 ? "church stamp unlocked" : "church stamps unlocked")
                    .font(AppFont.callout)
                    .foregroundStyle(Color.cgSecondaryText)

                Text("Follow in His Footsteps")
                    .font(AppFont.caption)
                    .foregroundStyle(Color.cgGold)
            }

            Spacer()

            ProgressRing(
                progress: min(Double(filteredStamps.count) / 25.0, 1.0),
                lineWidth: 8,
                size: 72,
                gradientColors: [.cgGold, .cgCrimson]
            )
            .overlay {
                Text("\(min(filteredStamps.count, 25))/25")
                    .font(AppFont.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.cgCharcoal)
            }
        }
        .cardStyle()
    }

    private var filtersCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Passport Filters")
                .font(AppFont.headline)
                .foregroundStyle(Color.cgCharcoal)

            Picker("Scope", selection: $selectedScope) {
                ForEach(FilterScope.allCases, id: \.self) { scope in
                    Text(scope.title).tag(scope)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedScope) { _, newValue in
                selectedValue = availableValues(for: newValue).first ?? FilterScope.allValue
            }

            HStack {
                Menu {
                    ForEach(availableValues(for: selectedScope), id: \.self) { value in
                        Button(value) {
                            selectedValue = value
                        }
                    }
                } label: {
                    filterPill(title: selectedValue, systemImage: "line.3.horizontal.decrease.circle.fill")
                }

                Spacer()

                Menu {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(option.title) {
                            selectedSort = option
                        }
                    }
                } label: {
                    filterPill(title: selectedSort.title, systemImage: "arrow.up.arrow.down.circle.fill")
                }
            }
        }
        .cardStyle()
    }

    private var emptyState: some View {
        VStack(spacing: Theme.spacingMD) {
            Image(systemName: "building.columns.crop.circle")
                .font(.system(size: 52, weight: .bold))
                .foregroundStyle(Color.cgGold)

            Text("Start collecting! Your first church awaits.")
                .font(AppFont.title3)
                .foregroundStyle(Color.cgCharcoal)
                .multilineTextAlignment(.center)

            Text("Adjust your filters or visit a new church to stamp your passport.")
                .font(AppFont.callout)
                .foregroundStyle(Color.cgSecondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.spacingXL)
        .cardStyle()
    }

    private func filterPill(title: String, systemImage: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
            Text(title)
                .lineLimit(1)
        }
        .font(AppFont.callout)
        .foregroundStyle(Color.cgCharcoal)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.cgIvory)
        .clipShape(Capsule())
        .roundedBorder(Color.cgGold.opacity(0.25), cornerRadius: Theme.radiusFull)
    }

    private func availableValues(for scope: FilterScope) -> [String] {
        let values: [String]

        switch scope {
        case .all:
            values = [FilterScope.allValue]
        case .city:
            values = stamps.compactMap(\.church.city)
        case .state:
            values = stamps.compactMap(\.church.state)
        case .country:
            values = stamps.compactMap(\.church.country)
        case .denomination:
            values = stamps.map(\.church.denomination)
        }

        let uniqueValues = Array(Set(values)).sorted()
        return [FilterScope.allValue] + uniqueValues
    }

    private var filteredStamps: [VisitStamp] {
        let filtered: [VisitStamp]

        if selectedScope == .all || selectedValue == FilterScope.allValue {
            filtered = stamps
        } else {
            filtered = stamps.filter { stamp in
                switch selectedScope {
                case .all:
                    return true
                case .city:
                    return stamp.church.city == selectedValue
                case .state:
                    return stamp.church.state == selectedValue
                case .country:
                    return stamp.church.country == selectedValue
                case .denomination:
                    return stamp.church.denomination == selectedValue
                }
            }
        }

        switch selectedSort {
        case .recent:
            return filtered.sorted { $0.visitedAt > $1.visitedAt }
        case .oldest:
            return filtered.sorted { $0.visitedAt < $1.visitedAt }
        case .alphabetical:
            return filtered.sorted { $0.church.name.localizedCaseInsensitiveCompare($1.church.name) == .orderedAscending }
        }
    }
}

private struct PassportStampCard: View {
    let stamp: VisitStamp

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Group {
                    if let photoURL = stamp.church.photoURLValue {
                        AsyncImage(url: photoURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        LinearGradient(
                            colors: [Color.cgCrimson.opacity(0.28), Color.cgGold.opacity(0.18)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .overlay {
                            Image(systemName: "building.columns.fill")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(Color.cgSurface.opacity(0.9))
                        }
                    }
                }
                .frame(height: 112)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusMD, style: .continuous))

                if stamp.church.isHistoric {
                    Label("Historic", systemImage: "sparkles")
                        .font(AppFont.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.cgCharcoal)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color.cgGold)
                        .clipShape(Capsule())
                        .padding(10)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(stamp.church.name)
                    .font(AppFont.headline)
                    .foregroundStyle(Color.cgCharcoal)
                    .lineLimit(2)

                Text(stamp.church.locationSummary)
                    .font(AppFont.caption)
                    .foregroundStyle(Color.cgSecondaryText)
                    .lineLimit(1)

                HStack {
                    Text(stamp.visitedAt.formatted(date: .abbreviated, time: .omitted))
                        .font(AppFont.caption2)
                        .foregroundStyle(Color.cgSecondaryText)

                    Spacer()

                    XPBadge(xp: stamp.xpEarned)
                }
            }

            Text(stamp.church.denomination.uppercased())
                .font(AppFont.caption2)
                .fontWeight(.bold)
                .foregroundStyle(Color.cgCrimson)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.cgCrimson.opacity(0.08))
                .clipShape(Capsule())
        }
        .padding(12)
        .background(Color.cgSurface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        .modifier(CardShadowModifier())
    }
}

private struct VisitStamp: Identifiable {
    let id: UUID
    let church: Church
    let visitedAt: Date
    let xpEarned: Int

    static let sampleData: [VisitStamp] = {
        let calendar = Calendar.current
        return [
            VisitStamp(id: UUID(), church: Church.mockList[0], visitedAt: calendar.date(byAdding: .day, value: -1, to: .now) ?? .now, xpEarned: 225),
            VisitStamp(id: UUID(), church: Church.mockList[1], visitedAt: calendar.date(byAdding: .day, value: -4, to: .now) ?? .now, xpEarned: 175),
            VisitStamp(id: UUID(), church: Church.mockList[2], visitedAt: calendar.date(byAdding: .day, value: -7, to: .now) ?? .now, xpEarned: 150),
            VisitStamp(id: UUID(), church: Church.mockList[3], visitedAt: calendar.date(byAdding: .day, value: -12, to: .now) ?? .now, xpEarned: 200),
            VisitStamp(id: UUID(), church: Church.mockList[4], visitedAt: calendar.date(byAdding: .day, value: -18, to: .now) ?? .now, xpEarned: 150),
        ]
    }()
}

private enum FilterScope: CaseIterable {
    static let allValue = "All"

    case all
    case city
    case state
    case country
    case denomination

    var title: String {
        switch self {
        case .all: return "All"
        case .city: return "City"
        case .state: return "State"
        case .country: return "Country"
        case .denomination: return "Faith"
        }
    }
}

private enum SortOption: CaseIterable {
    case recent
    case oldest
    case alphabetical

    var title: String {
        switch self {
        case .recent: return "Newest"
        case .oldest: return "Oldest"
        case .alphabetical: return "A-Z"
        }
    }
}

#Preview {
    CollectionView()
}
