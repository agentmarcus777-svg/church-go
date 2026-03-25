import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @State private var notificationsEnabled = true
    @State private var dailyReminder = true
    @State private var streakReminder = true
    @State private var showSignOutAlert = false
    @State private var showDeleteAlert = false

    private let exportSummary = """
    Church Go Profile Export
    Username: Blake
    Email: blake@churchgo.app
    Total Churches: 34
    Total XP: 2450
    Current Streak: 7 days
    """

    var body: some View {
        List {
            // Account section
            Section {
                HStack(spacing: 14) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.cgCrimson, .cgDeepRed],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text("B")
                                .font(AppFont.title3)
                                .foregroundStyle(.white)
                        }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Blake")
                            .font(AppFont.headline)
                            .foregroundStyle(Color.cgCharcoal)
                        Text("blake@churchgo.app")
                            .font(AppFont.caption)
                            .foregroundStyle(Color.cgSecondaryText)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.cgSecondaryText)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Account")
            }

            // Notifications
            Section {
                Toggle(isOn: $notificationsEnabled) {
                    SettingsRow(icon: "bell.fill", title: "Push Notifications", color: .cgCrimson)
                }
                .tint(Color.cgCrimson)

                Toggle(isOn: $dailyReminder) {
                    SettingsRow(icon: "clock.fill", title: "Daily Reminder", color: .cgGold)
                }
                .tint(Color.cgCrimson)
                .disabled(!notificationsEnabled)
                .opacity(notificationsEnabled ? 1.0 : 0.5)

                Toggle(isOn: $streakReminder) {
                    SettingsRow(icon: "flame.fill", title: "Streak Reminder", color: .orange)
                }
                .tint(Color.cgCrimson)
                .disabled(!notificationsEnabled)
                .opacity(notificationsEnabled ? 1.0 : 0.5)
            } header: {
                Text("Notifications")
            }

            // General
            Section {
                NavigationLink {
                    AppearanceSettingsView()
                } label: {
                    SettingsRow(icon: "app.fill", title: "Appearance", color: .cgCrimson)
                }

                NavigationLink {
                    DistanceSettingsView()
                } label: {
                    SettingsRow(icon: "ruler.fill", title: "Units & Region", color: .blue)
                }
            } header: {
                Text("General")
            }

            // Privacy
            Section {
                NavigationLink {
                    LegalDocumentView(
                        title: "Privacy Policy",
                        accent: .green,
                        sections: [
                            LegalSection(title: "Location Data", body: "Church Go requests your location to discover nearby churches and validate on-site check-ins within the allowed radius."),
                            LegalSection(title: "Account Data", body: "Your profile details, streaks, XP, and badges are stored with Supabase so they can sync across devices."),
                            LegalSection(title: "Photos", body: "If you choose to upload visit photos, they are stored securely in Supabase Storage and associated with your account."),
                        ]
                    )
                } label: {
                    SettingsRow(icon: "hand.raised.fill", title: "Privacy Policy", color: .green)
                }

                NavigationLink {
                    LegalDocumentView(
                        title: "Terms of Service",
                        accent: .cgSecondaryText,
                        sections: [
                            LegalSection(title: "Respectful Use", body: "Use Church Go responsibly and comply with church property rules, local laws, and posted visitation requirements."),
                            LegalSection(title: "Check-In Integrity", body: "XP, badges, and leaderboard placement depend on honest location validation. Fraudulent check-ins may be removed."),
                            LegalSection(title: "Availability", body: "Church data, badges, and map content may evolve as the service grows. Features can change without prior notice."),
                        ]
                    )
                } label: {
                    SettingsRow(icon: "doc.text.fill", title: "Terms of Service", color: .cgSecondaryText)
                }

                ShareLink(item: exportSummary) {
                    SettingsRow(icon: "square.and.arrow.down.fill", title: "Export My Data", color: .cgGold)
                }
            } header: {
                Text("Privacy & Legal")
            }

            // Danger zone
            Section {
                Button {
                    showSignOutAlert = true
                } label: {
                    SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", color: .cgDeepRed)
                }

                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    SettingsRow(icon: "trash.fill", title: "Delete Account", color: .cgDeepRed)
                }
            } header: {
                Text("Account Actions")
            }

            // App info
            Section {
                HStack {
                    Text("Version")
                        .font(AppFont.body)
                    Spacer()
                    Text("1.0.0")
                        .font(AppFont.body)
                        .foregroundStyle(Color.cgSecondaryText)
                }
            } footer: {
                VStack(spacing: 4) {
                    Text("Church Go")
                        .font(AppFont.headline)
                        .foregroundStyle(Color.cgCrimson)
                    Text("Follow in His Footsteps")
                        .font(AppFont.caption)
                        .foregroundStyle(Color.cgSecondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, Theme.spacingLG)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.cgBackground)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Sign Out", isPresented: $showSignOutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                hasCompletedOnboarding = false
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Account deletion requests are handled by support so visit history can be exported first. Email support@churchgo.app to continue.")
        }
    }
}

// MARK: - Settings Row

private struct SettingsRow: View {
    let icon: String
    let title: String
    var color: Color = .cgCrimson

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

            Text(title)
                .font(AppFont.body)
                .foregroundStyle(Color.cgCharcoal)
        }
    }
}

private struct AppearanceSettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.spacingLG) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Brand Preview")
                        .font(AppFont.title2)
                        .foregroundStyle(Color.cgCharcoal)

                    RoundedRectangle(cornerRadius: Theme.radiusXL, style: .continuous)
                        .fill(Color.cgSunriseGradient)
                        .frame(height: 180)
                        .overlay {
                            VStack(spacing: 10) {
                                Image(systemName: "building.columns.circle.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.white)
                                Text("Church Go")
                                    .font(AppFont.title)
                                    .foregroundStyle(.white)
                                Text("Follow in His Footsteps")
                                    .font(AppFont.callout)
                                    .foregroundStyle(.white.opacity(0.88))
                            }
                        }

                    Text("The shipped icon and UI theme use the crimson, gold, and ivory palette defined in the Church Go design system.")
                        .font(AppFont.callout)
                        .foregroundStyle(Color.cgSecondaryText)
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Typography")
                        .font(AppFont.title2)
                        .foregroundStyle(Color.cgCharcoal)

                    Text("SF Rounded keeps the app playful, chunky, and high contrast for fast scanning on the move.")
                        .font(AppFont.callout)
                        .foregroundStyle(Color.cgSecondaryText)
                }
                .cardStyle()
            }
            .padding(Theme.spacingMD)
            .padding(.bottom, Theme.spacingXXL)
        }
        .background(Color.cgBackground)
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DistanceSettingsView: View {
    @AppStorage("distanceUnit") private var distanceUnit = DistanceUnit.miles.rawValue
    @AppStorage("homeRegion") private var homeRegion = "United States"

    var body: some View {
        Form {
            Section("Distance Units") {
                Picker("Distance", selection: $distanceUnit) {
                    ForEach(DistanceUnit.allCases, id: \.rawValue) { unit in
                        Text(unit.title).tag(unit.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Home Region") {
                TextField("Country or region", text: $homeRegion)
            }

            Section("Preview") {
                Text(distanceUnit == DistanceUnit.miles.rawValue ? "0.5 mi away" : "0.8 km away")
                    .font(AppFont.headline)
                    .foregroundStyle(Color.cgCharcoal)
            }
        }
        .navigationTitle("Units & Region")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct LegalDocumentView: View {
    let title: String
    let accent: Color
    let sections: [LegalSection]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.spacingLG) {
                ForEach(sections) { section in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(section.title)
                            .font(AppFont.title3)
                            .foregroundStyle(accent)

                        Text(section.body)
                            .font(AppFont.callout)
                            .foregroundStyle(Color.cgCharcoal)
                    }
                    .cardStyle()
                }
            }
            .padding(Theme.spacingMD)
            .padding(.bottom, Theme.spacingXXL)
        }
        .background(Color.cgBackground)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct LegalSection: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

private enum DistanceUnit: String, CaseIterable {
    case miles
    case kilometers

    var title: String {
        switch self {
        case .miles:
            return "Miles"
        case .kilometers:
            return "Kilometers"
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
