import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@main
struct ChurchGoApp: App {
    @StateObject private var locationService = LocationService.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(locationService)
            } else {
                OnboardingView {
                    withAnimation(Theme.springAnimation) {
                        hasCompletedOnboarding = true
                    }
                }
                .environmentObject(locationService)
            }
        }
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    @State private var selectedTab: Tab = .explore

    enum Tab: String {
        case explore, collection, badges, profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ChurchMapView()
                .tabItem {
                    Label("Explore", systemImage: "map.fill")
                }
                .tag(Tab.explore)

            CollectionView()
                .tabItem {
                    Label("Collection", systemImage: "square.grid.2x2.fill")
                }
                .tag(Tab.collection)

            BadgesView()
                .tabItem {
                    Label("Badges", systemImage: "trophy.fill")
                }
                .tag(Tab.badges)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(Color.cgCrimson)
        .onAppear {
            #if canImport(UIKit)
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.cgSurface)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            #endif
        }
    }
}

#Preview("Main Tab View") {
    MainTabView()
        .environmentObject(LocationService())
}

#Preview("Onboarding") {
    OnboardingView()
        .environmentObject(LocationService())
}
