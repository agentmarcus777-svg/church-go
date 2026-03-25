import SwiftUI
import MapKit
#if canImport(UIKit)
import UIKit
#endif

struct ChurchMapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var showDetail = false

    var body: some View {
        ZStack(alignment: .top) {
            // Map
            Map(position: $viewModel.cameraPosition) {
                UserAnnotation()

                ForEach(viewModel.filteredChurches) { church in
                    Annotation(church.name, coordinate: church.coordinate) {
                        ChurchPin(
                            isVisited: viewModel.isVisited(church),
                            isSelected: viewModel.selectedChurch?.id == church.id
                        )
                        .onTapGesture {
                            viewModel.selectChurch(church)
                            #if canImport(UIKit)
                            let gen = UIImpactFeedbackGenerator(style: .light)
                            gen.impactOccurred()
                            #endif
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea(edges: .top)

            // Search bar overlay
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.cgSecondaryText)
                    TextField("Search churches...", text: $viewModel.searchText)
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
                    churches: viewModel.nearbyChurches(limit: 8),
                    visitedIDs: viewModel.visitedChurchIDs,
                    onSelect: { church in
                        viewModel.selectChurch(church)
                        showDetail = true
                    }
                )
            }
        }
        .background(Color.cgBackground)
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

#Preview {
    ChurchMapView()
}
