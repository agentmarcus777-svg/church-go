import SwiftUI
import MapKit

struct ChurchMapView: View {
    @StateObject private var viewModel = MapViewModel.preview
    @State private var showDetail = false
    @State private var searchText = ""

    var body: some View {
        ZStack(alignment: .top) {
            // Map
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.churches) { church in
                MapAnnotation(coordinate: church.coordinate) {
                    ChurchPin(
                        isVisited: viewModel.isVisited(church),
                        isSelected: viewModel.selectedChurch?.id == church.id
                    )
                    .onTapGesture {
                        viewModel.selectChurch(church)
                        let gen = UIImpactFeedbackGenerator(style: .light)
                        gen.impactOccurred()
                    }
                }
            }
            .ignoresSafeArea(edges: .top)

            // Search bar overlay
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.cgSecondaryText)
                    TextField("Search churches...", text: $searchText)
                        .font(AppFont.body)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusLG, style: .continuous))
                .modifier(CardShadowModifier())
                .padding(.horizontal, Theme.spacingMD)
                .padding(.top, 8)

                Spacer()
            }

            // Bottom sheet
            VStack {
                Spacer()
                NearbyChurchSheet(
                    churches: viewModel.churches,
                    visitedIDs: viewModel.visitedChurchIDs,
                    onSelect: { church in
                        viewModel.selectChurch(church)
                        showDetail = true
                    }
                )
            }
        }
        .sheet(isPresented: $showDetail) {
            if let church = viewModel.selectedChurch {
                ChurchDetailView(church: church, isVisited: viewModel.isVisited(church))
            }
        }
        .task {
            await viewModel.loadChurches()
        }
    }
}

