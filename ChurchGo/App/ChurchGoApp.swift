import SwiftUI

@main
struct ChurchGoApp: App {
    @StateObject private var locationService = LocationService()
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
            }
        }
    }
}

// MARK: - Main Tab View

struct MainTabView: View {
    @State private var selectedTab: Tab = .map

    enum Tab: String {
        case map, leaderboard, profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ChurchMapView()
                .tabItem {
                    Label("Explore", systemImage: "map.fill")
                }
                .tag(Tab.map)

            LeaderboardView()
                .tabItem {
                    Label("Ranks", systemImage: "trophy.fill")
                }
                .tag(Tab.leaderboard)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(Color.cgCrimson)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.cgSurface)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

